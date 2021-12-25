require 'pry-byebug'

class SeaCucumber
  attr_reader :initial_state
  attr_accessor :current_state, :step_count

  def initialize
    @initial_state = IO.read("input.txt").split("\n")
    @current_state = @initial_state.clone.map(&:clone)
    @step_count = 0
  end

  def step
    @step_count += 1
    next_state = Array.new(height) { '.' * width }
    # move east facing
    0.upto(height-1) do |y|
      0.upto(width-1) do |x|
        if @current_state[y][x] == '>' && @current_state[y][next_right_x(x)] == '.'
          next_state[y][x] = '.'
          next_state[y][next_right_x(x)] = '>'
        elsif @current_state[y][x] != '.'
          next_state[y][x] = @current_state[y][x]
        end
      end
    end
    @current_state = next_state.clone.map(&:clone)
    next_state = Array.new(height) { '.' * width }
    # move south facing
    0.upto(height-1) do |y|
      0.upto(width-1) do |x|
        if @current_state[y][x] == 'v' && @current_state[next_down_y(y)][x] == '.'
          next_state[y][x] = '.'
          next_state[next_down_y(y)][x] = 'v'
        elsif @current_state[y][x] != '.'
          next_state[y][x] = @current_state[y][x]
        end
      end
    end
    @current_state = next_state.clone.map(&:clone)
#    puts "Step #{@step_count}"
#    puts @current_state
  end

  def height
    @initial_state.size
  end

  def width
    @initial_state[0].size
  end

  def next_down_y(y)
    y+1 < height ? y+1 : 0
  end

  def next_right_x(x)
    x+1 < width ? x+1 : 0
  end
end

if $PROGRAM_NAME == __FILE__
  sc = SeaCucumber.new

#  puts "Initial state"
#  puts sc.initial_state

  while true
    previous_state = sc.current_state
    sc.step
    break if previous_state == sc.current_state
  end

  puts "Final state is after #{sc.step_count} steps"
#  puts sc.current_state
end
