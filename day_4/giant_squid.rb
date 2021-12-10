require 'pry-byebug'

class GiantSquid
  attr_reader :draws, :boards

  def initialize
    @bingo = IO.read("input.txt").split
    @draws = @bingo.shift.split(',').map(&:to_i)
    @winning_board_scores = []
    define_boards(@bingo)
    draw_numbers
  end

  def define_boards(input)
    @boards = []
    while(input.size > 0)
      board = []
      5.times do |row|
        board << input.shift(5).map(&:to_i)
      end
      board += board.transpose # now all the board's arrays are either horizontal numbers or vertical numbers, both possible for scoring
      @boards << board
    end
  end

  def draw_numbers
    winning_board = nil
    winning_draw = 0
    draws.each do |draw|
      remaining_boards = @boards.dup
      remaining_boards.each do |board|
        board.each do |row_or_column|
          row_or_column.delete(draw)
          if row_or_column.size.zero?
            winning_board = board
            winning_draw = draw
          end
        end
        if winning_board != nil
          @winning_board_scores << winning(winning_board, winning_draw)
          @boards.delete(winning_board)
          winning_board = nil
        end
      end
    end
  end

  def winning(board, draw)
    # divide by two because each board has arrays for the rows plus arrays for the columns
    (board.flatten.sum / 2) * draw
  end

  def winning_board_score
    @winning_board_scores.first
  end

  def last_winning_board_score
    @winning_board_scores.last
  end
end

if $PROGRAM_NAME == __FILE__
  gs = GiantSquid.new
  puts "Winning board score: #{gs.winning_board_score}"
  puts "Last winning board score: #{gs.last_winning_board_score}"
end
