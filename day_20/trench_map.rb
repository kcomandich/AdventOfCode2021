require 'pry-byebug'

class TrenchMap
  attr_reader :algorithm, :input_image
  attr_accessor :result_images

  def initialize
    input = IO.read('input.txt')
    @input_image = input.split("\n")
    @algorithm = @input_image.shift  # first line is the algorithm
    @input_image.shift # delete blank line

    @result_images = []
    image = surround_with_dots(@input_image).clone.map(&:clone)
    2.times do |i|
      result = enhance_image(image)
      image = result
      @result_images << result 
    end
  end

  def surround_with_dots(input_image)
    # add a padding of 10 rows of dots
    dot_row = '.' * input_image[0].size
    dot_column = '.' * 10
    10.times do |i|
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

    account_for_infinite_images(result_image)
    result_image
  end

  # infinite size means all extra space around the image starts as:
  # ...
  # ...
  # ...
  # and if the first element of the algorithm, which is 000000000 = '.........', is '#',
  # that means in the first round of image enhancing, all infinite space turns into '#'s.
  # On the second round, it starts as
  # ###
  # ###
  # ###
  # which is '#########' = 111111111 = 511 in decimal, so look up the algorithm at [511]
  def account_for_infinite_images(image)
    width = image[0].size
    height = image.size

    if (@algorithm[0] == '#' && image[2][2] == '#') || (@algorithm[511] == '#' && image[2][2] == '#')
      image.each do |row|
        row[0] = '#'
        row[1] = '#'
        row[height-2] = '#'
        row[height-1] = '#'
      end
      hash_row = '#' * width
      image[0] = hash_row 
      image[1] = hash_row 
      image[height-2] = hash_row
      image[height-1] = hash_row
    elsif (@algorithm[0] == '.' && image[2][2] == '.') || (@algorithm[511] == '.' && image[2][2] == '.')
      image.each do |row|
        row[0] = '.'
        row[1] = '.'
        row[height-2] = '.'
        row[height-1] = '.'
      end
      hash_row = '.' * width
      image[0] = hash_row 
      image[1] = hash_row 
      image[height-2] = hash_row
      image[height-1] = hash_row
    end
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
