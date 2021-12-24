require 'pry-byebug'

TARGET_REGEX = /target area: x=(-?\d*)..(-?\d*), y=(-?\d*)..(-?\d*)/.freeze

class TrickShot
  attr_reader :x_range, :y_range
  attr_accessor :position, :velocities

  def initialize
    input = IO.read('input.txt')
    coordinates = input.match(TARGET_REGEX)
    @x_range = { min: coordinates[1].to_i, max: coordinates[2].to_i }
    @y_range = { min: coordinates[3].to_i, max: coordinates[4].to_i }
    @velocities = []
  end

  # range of velocities to look for:
  # x = always positive, greater than zero (zero would fire it straight up)
  # y = start at the highest y value to maximize the y position, can be positive because drag reduces it.
  #
  # Find the velocity that puts the position in the range, with the highest y position on its trajectory
  def find_velocity
    1.upto(@x_range[:max]) do |x|
      @y_range[:min].upto(-@y_range[:min]) do |y| # assuming y target is negative, guessing how high to go to
        velocity = { x: x, y: y } 
        @position = { x: 0, y: 0 }
        max_height = 0
#        puts "Trying velocity #{velocity}"
        while ! in_range && ! past_range
          step(velocity)
          max_height = position[:y] > max_height ? position[:y] : max_height
        end
        if in_range
          @velocities << { velocity: { x: x, y: y }, height: max_height }
        end
      end
    end
  end

  def step(velocity)
    @position[:x] += velocity[:x]
    @position[:y] += velocity[:y]
    # drag
    if velocity[:x] > 0
      velocity[:x] -= 1
    elsif velocity[:x] < 0
      velocity[:x] += 1
    end
    #gravity
    velocity[:y] -= 1
    #puts "Step to position #{@position}, velocity now #{velocity}"
  end

  def in_range
    (@position[:x] >= @x_range[:min] && @position[:x] <= @x_range[:max]) && (@position[:y] >= @y_range[:min] && @position[:y] <= @y_range[:max])
  end

  def past_range
    @position[:x] > @x_range[:max] || @position[:y] < @y_range[:min]
  end

  def best_velocity
    @velocities.max{|a,b| a[:height] <=> b[:height]}
  end
end

if $PROGRAM_NAME == __FILE__
  ts = TrickShot.new
  puts "X Range: #{ts.x_range} Y Range: #{ts.y_range}"
  ts.find_velocity
  best = ts.best_velocity
  puts "Velocity to get in range with highest y position: #{best}"
  puts "Highest y position: #{best[:height]}"
  puts "Number of velocities that get in range: #{ts.velocities.size}"
#  puts ts.velocities
end
