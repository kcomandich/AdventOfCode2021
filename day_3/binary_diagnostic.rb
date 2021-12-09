require 'pry-byebug'

class BinaryDiagnostic
  def initialize
    @report = IO.read("input.txt").split.map{|n| n.split('')}.each{|a| a.map!(&:to_i)}
  end

  def gamma_binary
    # or - another method - sum all the 1s and 0s together, and use 1 if it's greater than half the count, 0 otherwise
    @report.transpose.map{|a| a.max_by{|n| a.count(n)} }
  end

  def gamma_rate
    gamma_binary.join.to_i(2)
  end

  def epsilon_rate
    invert(gamma_binary).join.to_i(2)
  end

  def invert(binary_array)
    binary_array.map{|n| (n - 1).abs}
  end

  def power_consumption
    gamma_rate * epsilon_rate
  end

  def oxygen_generator_rating
    filter_by_bit_criteria(@report.dup, 0, 1, :most).join.to_i(2)
  end

  def co2_scrubber_rating
    filter_by_bit_criteria(@report.dup, 0, 0, :least).join.to_i(2)
  end

  def life_support_rating
    oxygen_generator_rating * co2_scrubber_rating
  end

  def filter_by_bit_criteria(array, n, value, criteria)
    t = array.transpose
    value_count = t[n].count(value)
    if criteria == :most
      if value_count >= (t[n].count - value_count)
        array.delete_if{|e| e[n] != value} 
      else
        array.delete_if{|e| e[n] != (value - 1).abs} 
      end
    else
      if value_count <= (t[n].count - value_count)
        array.delete_if{|e| e[n] != value} 
      else
        array.delete_if{|e| e[n] != (value - 1).abs} 
      end
    end
    return array if array.count <= 1
    filter_by_bit_criteria(array, n+1, value, criteria)
  end
end

if $PROGRAM_NAME == __FILE__
  bd = BinaryDiagnostic.new

  puts "Gamma Rate: #{bd.gamma_rate}; Epsilon Rate: #{bd.epsilon_rate}; Power Consumption: #{bd.power_consumption}"
  puts "Oxygen Generator Rating: #{bd.oxygen_generator_rating}; CO2 Scrubber Rating: #{bd.co2_scrubber_rating}; Life Support Rating: #{bd.life_support_rating}"
end
