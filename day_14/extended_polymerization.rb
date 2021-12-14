require 'pry-byebug'

class ExtendedPolymerization
  attr_accessor :polymer

  def initialize
    input = IO.read('input.txt').split("\n")
    @polymer = input.shift.split('')
    input.shift # blank line
    @pair_insertions = {}
    @pair_insertions = Hash[input.map{ |line| line.match(/(\w\w) -> (\w)/)[1..2] }]
  end

  def insert
    working_copy = [] 
    @polymer.each_cons(2) do |pair|
      working_copy << pair[0]
      working_copy << @pair_insertions[pair.join]
    end
    working_copy << @polymer.last
    @polymer = working_copy
  end

  def most_common_element
    elements = []
    ('A'..'Z').each do |letter|
      elements << @polymer.count(letter)
    end
    elements.sort!
    elements.pop
  end

  # refactor
  def least_common_element
    elements = []
    ('A'..'Z').each do |letter|
      elements << @polymer.count(letter)
    end
    elements.sort!
    while elements.first == 0
      elements.shift
    end
    elements.shift
  end
end

if $PROGRAM_NAME == __FILE__
  ep = ExtendedPolymerization.new
  10.times{ ep.insert }
  puts ep.polymer.join
  puts "Most common element: #{ep.most_common_element}"
  puts "Least common element: #{ep.least_common_element}"
  puts "Puzzle result: #{ep.most_common_element - ep.least_common_element}"
end
