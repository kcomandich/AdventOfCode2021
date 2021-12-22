require 'pry-byebug'

class TrenchMap
  attr_reader :algorithm, :input_image
  attr_accessor :result_images

  def initialize
    input = IO.read('sample.txt')
    @input_image = input.split("\n")
    @algorithm = @input_image.shift  # first line is the algorithm
    @input_image.shift # delete blank line

    @result_images = []
    surround_with_dots(@input_image)
    @result_images[0] = enhance_image(@input_image)
    @result_images[1] = enhance_image(@result_images[0])
  end

  def surround_with_dots(input_image)
    # the example adds padding of 5 rows of dots, so try that
    dot_row = '.' * input_image[0].size
    dot_column = '.' * 5 
    5.times do |i|
      input_image.unshift(dot_row)
      input_image.push(dot_row)
    end
    input_image.map!{|line| dot_column + line + dot_column }
  end

  def enhance_image(input_image)
    image_width = input_image[0].size
    image_height = input_image.size
    result_image = input_image.clone.map(&:clone)
    # [1, 1] to [image_width-2, image_height-2]
    0.upto(image_width-2) do |x|
      0.upto(image_height-2) do |y|
        binary_number = input_image[y-1].slice((x-1)..(x+1)) 
        binary_number += input_image[y].slice((x-1)..(x+1))
        binary_number += input_image[y+1].slice((x-1)..(x+1))
        binary_number.tr!('.#', '01')
        decimal = to_decimal(binary_number)
        result_image[y-1][x-1] = @algorithm[decimal]
      end
    end
    result_image
  end

  def to_decimal(binary)
    binary.reverse.chars.map.with_index do |digit, index|
      digit.to_i * 2**index
    end.sum
  end

  def number_of_lit_pixels(input_image)
    input_image.sum do |row|
      row.count('#')
    end
  end
end

if $PROGRAM_NAME == __FILE__
  tm = TrenchMap.new
  puts "Image Enhancement Algorith: \n"
  puts tm.algorithm
  puts "\nInput Image:"
  tm.input_image.each{|line| puts line}
  tm.result_images.each do |image|
    puts "\nResult Image:"
    puts image
  end
  puts "Number of lit pixels in final image: #{tm.number_of_lit_pixels(tm.result_images[1])}"
end
