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
    puts "\n"
    colors.each do |color|
      color_index = @@COLOR_LIST.index(color)
      print " ".send(@@BACKGROUND_COLORS[color_index]) + " "
    end
    print "  "
  end

end