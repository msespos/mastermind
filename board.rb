class Board

  require_relative 'colors.rb'
  include Colors

  attr_reader :board_state

  def initialize
    @board_state = []
  end

  def update_board_state(board_update)
    @board_state.push(board_update)
  end

  def rounds_played
    @board_state.length
  end

  def last_guesses
    @board_state[-1][0]
  end

  def last_score
    @board_state[-1][1]
  end

  # display the colors for a guess or solution
  def display_colors(colors)
    colors.each do |color|
      color_index = @@COLOR_LIST.index(color)
      print " ".send(@@BACKGROUND_COLORS[color_index]) + " "
    end
    print "  "
  end

  # display the score (black and white "pegs")
  def display_score(score)
    puts (" ".on_black + " ") * score[0] + (" ".on_white + " ") * score[1]
  end

  # display the board (all rows played so far)
  def display_current_board(board_state)
    puts "\n"
    board_state.each do |row|
      display_colors(row[0])
      display_score(row[1])
      puts "\n"
    end
  end

end