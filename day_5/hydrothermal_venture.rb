require 'pry-byebug'

class HydrothermalVenture
  attr_accessor :diagram

  def initialize
    report = IO.read("input.txt").split("\n")
    @lines = []
    max_x = 0
    max_y = 0
    report.each do |line|
      (x1, y1, x2, y2) = line.match(/(\d+),(\d+) -> (\d+),(\d+)/)[1..4].map(&:to_i)
      max_x = x1 if x1 > max_x
      max_x = x2 if x2 > max_x
      max_y = y1 if y1 > max_y
      max_y = y2 if y2 > max_y
      @lines << { :start => [x1, y1], :end => [x2, y2] }
    end
    @diagram = Array.new(max_x + 1) { Array.new(max_y + 1) { 0 }}
    map_lines
  end

  def map_lines
    @lines.each do |line|
      # I have my x and y coordinates confused but this works
      y1 = line[:start][0]
      x1 = line[:start][1]
      y2 = line[:end][0]
      x2 = line[:end][1]
#      puts "drawing line from #{y1},#{x1} to #{y2},#{x2}"
      while( x1 != x2 || y1 != y2 ) do
        if x1 == x2 &&  y1 < y2
          @diagram[x1][y1] += 1
          y1 += 1
        elsif x1 == x2 && y1 > y2
          @diagram[x1][y1] += 1
          y1 -= 1
        elsif y1 == y2 && x1 < x2
          @diagram[x1][y1] += 1
          x1 += 1
        elsif y1 == y2 && x1 > x2
          @diagram[x1][y1] += 1
          x1 -= 1
        elsif x1 < x2 && y1 < y2
          @diagram[x1][y1] += 1
          x1 += 1
          y1 += 1
        elsif x1 < x2 && y1 > y2
          @diagram[x1][y1] += 1
          x1 += 1
          y1 -= 1
        elsif x1 > x2 && y1 < y2
          @diagram[x1][y1] += 1
          x1 -= 1
          y1 += 1
        else
          @diagram[x1][y1] += 1
          x1 -= 1
          y1 -= 1
        end
        @diagram[x1][y1] += 1 if x1 == x2 && y1 == y2 # don't skip the end of the line
      end
    end
  end

  def points_where_two_lines_overlap
    @diagram.flatten.count{|e| e >= 2 }
  end
end

if $PROGRAM_NAME == __FILE__
  hv = HydrothermalVenture.new
#  puts "Diagram: "
#  pp hv.diagram
  puts "Points where at least two lines overlap: #{hv.points_where_two_lines_overlap}"
end
