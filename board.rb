class Board

  attr_reader :board_state

  def initialize
    @board_state = []
  end

  def update_board_state(board_update)
    @board_state.push(board_update)
  end

end