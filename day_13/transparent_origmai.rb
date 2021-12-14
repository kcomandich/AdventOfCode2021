require 'pry-byebug'

class TransparentOrigami
  def initialize
    input = IO.read("input.txt").split("\n")
    (@fold_instructions, @dots) = input.partition {|e| e.start_with?('fold')}
    @dots.pop # last one is the newline
    @dots.map!{|dot| dot.split(',').map(&:to_i)}
    max_x = @dots.max{|a,b| a[0] <=> b[0]}[0] + 1
    max_y = @dots.max{|a,b| a[1] <=> b[1]}[1] + 1
    puts max_x
    puts max_y
    @paper = Array.new(max_y) { Array.new(max_x) { '.'} }
    apply_dots
    fold
  end

  def print_paper
    @paper.map(&:join)
  end

  def apply_dots
    @dots.each do |dot|
      @paper[dot[1]][dot[0]] = '#'
    end
  end

  def fold
    @fold_instructions.each do |fold|
      if fold.match(/fold along y/)
        fold_line =  fold.match(/fold along y=(\d*)/)[1].to_i
        # combine lines fold_line - 1 and fold_line + 1, etc until we get to zero
        counter = 1
        while fold_line - counter >= 0
          @paper[fold_line - counter].each.with_index do |spot,i|
            @paper[fold_line - counter][i] = '#' if spot == '#' || @paper[fold_line + counter][i] == '#'
          end
          counter += 1
        end
        @paper.pop(fold_line + 1)
      else
        fold_line =  fold.match(/fold along x=(\d*)/)[1].to_i
        @paper.each.with_index do |line, i|
          counter = 1
          while fold_line - counter >= 0
            @paper[i][fold_line - counter] = '#' if line[fold_line - counter] == '#' || @paper[i][fold_line + counter] == '#'
            counter += 1
          end
          @paper[i].pop(line.size - fold_line)
        end
      end
      break # stop after first fold, for part 1
    end
  end

  def count_dots
    @paper.flatten.count {|e| e == '#'}
  end
end

if $PROGRAM_NAME == __FILE__
  origami = TransparentOrigami.new
  puts "Paper after folding:"
#  puts origami.print_paper
  puts "with #{origami.count_dots} dots"
end
