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

  # display the color blocks
  def display_colors(colors)
    colors.each do |color|
      color_index = @@COLOR_LIST.index(color)
      print " ".send(@@BACKGROUND_COLORS[color_index]) + " "
    end
    print "  "
  end

  def display_score(score)
    puts (" ".on_black + " ") * score[0] + (" ".on_white + " ") * score[1]
  end

  def display_current_board(board_state)
    board_state.each do |row|
      display_colors(row[0])
      display_score(row[1])
      puts "\n"
    end
  end

end