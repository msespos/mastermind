class Game

  def initialize
    @board = Board.new
    @num_rounds = 0
    @user_game_selection = 0
    @solution = []
  end

  # create a solution based on the game version selected
  def create_solution(game_version)
    if game_version == "guesser"
      @solution = Code.new.create_random_code
    elsif game_version == "creator"
      @solution = Code.new.get_user_code("solution")
    end
  end

  # play a round of the chosen version of the game
  def play_round(game_version)
    round = Round.new
    @num_rounds == 11 ? (puts "Last round!") : (puts "#{12 - @num_rounds} rounds left!")
    puts "\n\nRound #{@num_rounds + 1}:\n\n"
    if game_version == "guesser"
      board_update = round.play(@solution, "guesser", @board)
    elsif game_version == "creator"
      puts "Computer is guessing:"
      board_update = round.play(@solution, "creator", @board)
    end
    if game_version == "creator"
      puts "\n"
      @board.display_colors(@solution)
      puts "\n"
    end
    @board.update_board_state(board_update)
    @board.display_current_board(@board.board_state)
    @num_rounds += 1
    round
  end

  # report the state of the game to the user
  def report_state(game_version, round)
    if game_version == "guesser"
      if @num_rounds == 12
        round.win_state ? (puts "You win!") : (puts "12 rounds are up. You lose!")
      else
        round.win_state ? (puts "You win!") : (puts "Try again!")
      end
    elsif game_version == "creator"
      if @num_rounds == 12
        round.win_state ? (puts "Computer wins!") : (puts "12 rounds are up. Computer loses!")
      else
        if round.win_state
          puts "Computer wins!"
        else
          puts "Press return to play another round"
          gets.chomp
        end
      end
    end
  end

  # play a full 12-round game
  def play(game_version)
    create_solution(game_version)
    game_finished = false
    while !game_finished
      round = play_round(game_version)
      report_state(game_version, round)
      game_finished = true if round.num_exact_matches == 4 || @num_rounds == 12
      puts "\n\n"
    end
  end

  def display_intro
    puts <<~HEREDOC

      Welcome to Mastermind!
      Would you like to be the guesser or the creator of the secret code?
      Enter 1 to be the guesser
      Enter 2 to be the creator

    HEREDOC
  end

  def get_user_game_selection
    until @user_game_selection == "1" || @user_game_selection == "2"
      puts "Please enter 1 or 2"
      @user_game_selection = gets.chomp
      puts "\n"
    end
  end

  # start the game by getting the user's game selection and playing that version
  def start
    display_intro
    get_user_game_selection
    @user_game_selection == "1" ? play("guesser") : play("creator")
  end

end