require 'colorize'

class Code

  @@COLOR_LIST = ["r", "y", "g", "c", "b", "m"]

  # create a randomized code
  def create_random_code
    random_code = []
    0.upto(3) { random_code.push(@@COLOR_LIST.sample) }
    random_code
  end

  # print request for a code from user
  def request_code(type)
    choose = type == "guess" ? "Guess" : "Select"
    choice = type == "guess" ? "guess" : "selection"
    puts <<~HEREDOC
      #{choose} four colors from the following list
      #{"red".light_red}, #{"yellow".light_yellow}, #{"green".light_green}, \
      #{"cyan".light_cyan}, #{"blue".light_blue}, and #{"magenta".light_magenta}
      Use the first letter of each color (in lower case) for your #{choice}
      e.g. rygc or rrbb

    HEREDOC
  end

  # check that a code has exactly four colors
  def length_correct?(user_guesses)
    user_guesses.length == 4
  end

  # check that a code has only valid colors
  def colors_correct?(user_guesses)
    user_guesses.all? { |color| @@COLOR_LIST.include?(color) }
  end

  # obtain a code from the user, reprompting until it is valid
  def get_user_code(type)
    user_code = []
    request_code(type)
    choices = type == "guess" ? "guesses" : "selections"
    until length_correct?(user_code) && colors_correct?(user_code)
      puts "Please enter your four #{choices}."
      user_code = gets.chomp.downcase.split("")
    end
    user_code
  end

end

class Round

  @@COLOR_LIST = ["r", "y", "g", "c", "b", "m"]
  @@BACKGROUND_COLORS = ["on_light_red", "on_light_yellow",
                          "on_light_green", "on_light_cyan",
                          "on_light_blue", "on_light_magenta"]
  
  attr_reader :num_exact_matches, :win_state

  def initialize
    @exact_matches = []
    @num_exact_matches = 0
    @num_color_only_matches = 0
    @win_state = false
  end

  # identify the number of exact matches and store it in @num_exact_matches
  def find_exact_matches(guesses, solution)
    @exact_matches = guesses.zip(solution).map { |x, y| x == y }
    @num_exact_matches = @exact_matches.count(true)
  end

  # identify the number of color-only matches and store it in @num_color_only_matches
  def find_color_only_matches(guesses, solution)
    guesses_without_exact_matches = guesses.zip(solution).delete_if { |x, y| x == y }
    remaining_guesses = guesses_without_exact_matches.transpose[0]
    remaining_solution = guesses_without_exact_matches.transpose[1]
    # https://stackoverflow.com/questions/37800483/
      # intersections-and-unions-in-ruby-for-sets-with-repeated-elements
    if (remaining_guesses | remaining_solution)
      color_only_matches = (remaining_guesses | remaining_solution).flat_map do |entry|
        [entry] * [remaining_guesses.count(entry), remaining_solution.count(entry)].min
      end
    else
      color_only_matches = []
    end
    @num_color_only_matches = color_only_matches.length
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

  # display the text describing the score for a round
  def display_matches
    exact_noun = @num_exact_matches == 1 ? "match" : "matches"
    color_only_noun = @num_color_only_matches == 1 ? "match" : "matches"
    if @num_exact_matches == 4
      @win_state = true
      puts "4 exact matches."
    else
      puts "#{@num_exact_matches} exact #{exact_noun} and "\
          "#{@num_color_only_matches} color-only #{color_only_noun}."
    end
    puts "\n\n"
  end

  # display the colors and text representing the score for a round
  def display_score(guesses, solution, game_version)
    if game_version == "creator"
      display_colors(solution)
    end
    puts "\n"
    display_colors(guesses)
    puts (" ".on_black + " ") * @num_exact_matches +
        (" ".on_white + " ") * @num_color_only_matches + "\n\n"
    display_matches
  end

  def update_computer_guesses(computer_guesses, num_rounds, solution)
    if num_rounds == 0
      return @computer_guesses = Code.new.create_random_code
    else
      return @computer_guesses = @computer_guesses.each_with_index do |guess, i|
        if guess != solution[i]
          @computer_guesses[i] = @@COLOR_LIST.sample
        end
      end
    end
  end

  # play a round
  def play(solution, game_version, num_rounds = 0)
    p solution
    if game_version == "guesser"
      guesses = Code.new.get_user_code("guess")
    elsif game_version == "creator"
      guesses = update_computer_guesses(@computer_guesses, num_rounds, solution)
    end
    find_exact_matches(guesses, solution)
    find_color_only_matches(guesses, solution)
    display_score(guesses, solution, game_version)
  end

end

class Game

  def initialize
    @round = Round.new
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
    @num_rounds == 11 ? (puts "Last round!") : (puts "#{12 - @num_rounds} rounds left!")
    puts "\n\nRound #{@num_rounds + 1}:\n\n"
    if game_version == "guesser"
      @round.play(@solution, "guesser")
    elsif game_version == "creator"
      puts "Computer is guessing:"
      @round.play(@solution, "creator", @num_rounds)
    end
    @num_rounds += 1
  end

  # report the state of the game to the user
  def report_state(game_version)
    if game_version == "guesser"
      if @num_rounds == 12
        @round.win_state ? (puts "You win!") : (puts "12 rounds are up. You lose!")
      else
        @round.win_state ? (puts "You win!") : (puts "Try again!")
      end
    elsif game_version == "creator"
      if @num_rounds == 12
        @round.win_state ? (puts "Computer wins!") : (puts "12 rounds are up. Computer loses!")
      else
        puts "Press return to play another round"
        gets.chomp
      end
    end
  end

  # play a full 12-round game
  def play(game_version)
    create_solution(game_version)
    while @round.num_exact_matches != 4 && @num_rounds < 12
      play_round(game_version)
      report_state(game_version)
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

game = Game.new
game.start