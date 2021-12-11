require 'pry-byebug'

class DumboOctopus
  attr_accessor :number_of_flashes
  attr_accessor :board, :first_simultaneous_flash

  def initialize
    input = IO.read("input.txt").split("\n")
    @board = Array.new(10) { Array.new }
    input.each.with_index do |line,i|
      @board[i] = line.split('').map(&:to_i)
    end
    @flashed = Array.new(10) { Array.new(10) { 0 }}
    @number_of_flashes = 0
    @first_simultaneous_flash = -1
  end

  def step(num)
    @flashed = Array.new(10) { Array.new(10) { 0 }}
    @board.each.with_index do |line, x|
      line.each.with_index do |o, y|
        # energy level increases by 1
        @board[x][y] += 1 unless @flashed[x][y] == 1
        if @board[x][y] > 9
          # any octopus with energy greater than 9 flashes
          flash(x,y)
        end
      end
    end
    if @board.flatten.sum == 0 && @first_simultaneous_flash == -1
      @first_simultaneous_flash = num
    end
  end

  def flash(x,y)
    if @flashed[x][y] != 1
      @number_of_flashes += 1
      # all octopuses that flash reset energy to 0
      @board[x][y] = 0
      @flashed[x][y] = 1

      # this increases energy of all adjacent octopuses by 1, including diagonally adjacent
      increase(x+1, y)
      increase(x+1, y+1)
      increase(x, y+1)
      increase(x-1, y)
      increase(x-1, y-1)
      increase(x, y-1)
      increase(x+1, y-1)
      increase(x-1, y+1)
      # this continues as long as there are octopuses have their energy increase beyond 9
    end
  end

  def increase(x,y)
    if x >= 0 && y >= 0 && @board[x] && @board[x][y]
#      puts "increase #{x},#{y} #{board[x][y]} + 1"
      @board[x][y] += 1 unless @flashed[x][y] == 1
      # if this causes those octopuses to have energy greater than 9, they also flash
      if @board[x][y] > 9
        flash(x,y)
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
  d = DumboOctopus.new
  num = 250
  num.times do |i|
    d.step(i)
  end
  puts "Number of flashes #{d.number_of_flashes}"
  puts "First simultaneous flash: #{d.first_simultaneous_flash}"
  puts "Current state of board after #{num} steps:"
  pp d.board
end
