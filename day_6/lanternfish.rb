require 'pry-byebug'

class LanternFish
  def initialize
    input = IO.read("input.txt").split(',').map(&:to_i)
    @fish = Array.new(9) { 0 }
    input.each do |f|
      @fish[f] += 1
    end
  end

  def new_day
    current_fish = @fish.dup
    current_fish.each.with_index do |f,i|
      if i == 0
        @fish[6] = f
        @fish[8] = f
      elsif i == 7
        @fish[6] += f
      else
        @fish[i-1] = f
      end
    end
  end

  def number_of_fish
    puts "Fish: "
    pp @fish
    @fish.sum
  end
end

if $PROGRAM_NAME == __FILE__
  lf = LanternFish.new
  num = 256
  num.times do |day|
    lf.new_day
  end
  puts "Final number of lantern fish after #{num} days: #{lf.number_of_fish}"
end
