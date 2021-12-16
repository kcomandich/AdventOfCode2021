require 'pry-byebug'

class Chiton
  attr_reader :risk_level
  attr_accessor :path_total

  def initialize
    @risk_level = IO.read('input.txt').split("\n").map{|line| line.split('').map(&:to_i) }
    @path_total = find_path(@risk_level, @risk_level[0].length, @risk_level.length)
  end

  def find_path(remaining_cavern, width, height)
#    puts "remaining cavern"
#    pp remaining_cavern
    return remaining_cavern if remaining_cavern.kind_of?(Integer)

    if width == 1 && height == 1
      return 0 # already counted this element
    elsif width == 1
      return remaining_cavern[1][0] + find_path(remaining_cavern.last(height-1), width, height - 1)
    elsif height == 1
      return remaining_cavern[0][1] + find_path(remaining_cavern.map{|line| line.last(width-1)}, width - 1, height)
    end

    path_x = remaining_cavern[0][1] + find_path(remaining_cavern.map{|line| line.last(width-1)}, width - 1, height)
    path_y = remaining_cavern[1][0] + find_path(remaining_cavern.last(height-1), width, height - 1)

    return path_x > path_y ? path_y : path_x
  end
end

if $PROGRAM_NAME == __FILE__
  c = Chiton.new
#  pp c.risk_level
  puts "Lowest total risk path has #{c.path_total} risk"
end
