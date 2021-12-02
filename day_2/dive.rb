require 'pry-byebug'

class Dive
  attr_accessor :horizontal_position, :depth, :aim

  def initialize
    @horizontal_position = 0
    @depth = 0
    @aim = 0
    process_commands(IO.read("input.txt").split)
  end

  def process_commands(input)
    input.each_with_index do |command, i|
      case command
      when /forward/
        forward(input[i+1].to_i)
      when /down/
        down(input[i+1].to_i)
      when /up/
        up(input[i+1].to_i)
      end
    end
  end

  def forward(x)
    @horizontal_position += x
    @depth += @aim * x
  end

  def up(y)
    @aim -= y
  end

  def down(y)
    @aim += y
  end
end

if $PROGRAM_NAME == __FILE__
  d = Dive.new
  puts "Horizontal position: #{d.horizontal_position}; Depth: #{d.depth}; Aim: #{d.aim}"
  puts "Horizontal position multiplied by depth: #{d.horizontal_position * d.depth}"
end
