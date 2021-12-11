require 'pry-byebug'

class LanternFish
  attr_accessor :fish

  def initialize
    @fish = IO.read("input.txt").split(',').map(&:to_i)
  end

  def new_day
    current_fish = @fish.dup
    current_fish.each.with_index do |f,i|
      if f == 0
        @fish[i] = 6
        @fish << 8
      else
        @fish[i] -= 1
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
  lf = LanternFish.new
  80.times do |day|
    lf.new_day
  end
  puts "Final number of lantern fish: #{lf.fish.size}"
end
