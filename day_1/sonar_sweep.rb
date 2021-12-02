require 'pry-byebug'

class SonarSweep
  attr_reader :input, :three_measurement_windows

  def initialize
    @input = IO.read("input.txt").split.map(&:to_i)
    @three_measurement_windows = [] 
    split_into_threes
  end

  def split_into_threes
    input.each_with_index do |n,i|
      window = input.slice(i, 3)
      three_measurement_windows << window unless window.size != 3
    end
  end

  def number_of_increases
    previous = 999999
    count = 0
    input.each do |n|
      count += 1 if n > previous
      previous = n
    end
    count
  end

  def number_of_increases_in_three_measurement_windows
    previous = 999999999999
    count = 0
    three_measurement_windows.each do |w|
      count += 1 if w.sum > previous
      previous = w.sum
    end
    count
  end
end

if $PROGRAM_NAME == __FILE__
  ss = SonarSweep.new
  puts "Number of depths: #{ss.input.size}"
  puts "Number of individual increasing depths: #{ss.number_of_increases}"
  puts "Number of three measurement window increasing depths: #{ss.number_of_increases_in_three_measurement_windows}"
end
