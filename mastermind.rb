require 'colorize'

class Player
end

class Round

  attr_reader :num_exact_matches, :did_user_win

  def initialize
    @num_exact_matches = 0
    @num_color_only_matches = 0
    @did_user_win = false
  end

  # identify the number of exact matches and store it in @num_exact_matches
  def find_exact_matches(guesses, solution)
    exact_matches = guesses.zip(solution).map { |x, y| x == y }
    @num_exact_matches = exact_matches.count(true)
  end

  # identify the number of color-only matches and store it in @num_color_only_matches
  def find_color_only_matches(guesses, solution)
    guesses_without_exact_matches = guesses.zip(solution).delete_if { |x, y| x == y }
    color_only_matches = guesses_without_exact_matches.transpose[0] & guesses_without_exact_matches.transpose[1]
    @num_color_only_matches = color_only_matches.length unless color_only_matches == false
  end
  
  def display_guesses(guesses)
    puts "\n"
    guesses.each do |guess|
      if guess == "r"
        print " ".on_light_red + " "
      elsif guess == "y"
        print " ".on_light_yellow + " "
      elsif guess == "g"
        print " ".on_light_green + " "
      elsif guess == "c"
        print " ".on_light_cyan + " "
      elsif guess == "b"
        print " ".on_light_blue + " "
      elsif guess == "m"
        print " ".on_light_magenta + " "
      end
    end
    print "  "
  end

  def display_score(guesses, solution, game_version)
    display_guesses(guesses)
    puts "\n\n"
    if game_version == "creator"
      display_guesses(solution)
      puts "\n\n"
    end
    if @num_exact_matches == 4
      @did_user_win = true
      puts "4 exact matches.\n\n"
      puts (" ".on_black + " ") * 4
    elsif @num_exact_matches == 1 && @num_color_only_matches == 1
      puts "1 exact match and 1 color-only match.\n\n"
      puts " ".on_black + " " + " ".on_white
    elsif @num_exact_matches == 1 && @num_color_only_matches != 1
      puts "1 exact match and #{@num_color_only_matches} "\
          "color-only matches.\n\n"
      puts " ".on_black + " " + (" ".on_white + " ") *
          @num_color_only_matches
    elsif @num_exact_matches != 1 && @num_color_only_matches == 1
      puts "#{@num_exact_matches} exact matches and 1 color-only match.\n\n"
      puts (" ".on_black + " ") * @num_exact_matches +
      " ".on_white
    else
      puts "#{@num_exact_matches} exact matches and "\
          "#{@num_color_only_matches} color-only matches.\n\n"
      puts (" ".on_black + " ") * @num_exact_matches + 
          (" ".on_white + " ") * @num_color_only_matches
    end
    puts "\n"
  end

  # play a round
  def play(solution, game_version)
    p solution
    if game_version == "guesser"
      guesses = Code.new.get_user_code("guess")
    elsif game_version == "creator"
      guesses = Code.new.create_random_code
    end
    find_exact_matches(guesses, solution)
    find_color_only_matches(guesses, solution)
    display_score(guesses, solution, game_version)
  end

end

class Code

  @@COLOR_INDEX = ["r", "y", "g", "c", "b", "m"]

  # create a randomized code
  def create_random_code
    random_code = []
    0.upto(3) { random_code.push(rand(6)) }
    random_code.each_with_index { |num, i| random_code[i] = @@COLOR_INDEX[num] }
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
    user_guesses.all? { |color| @@COLOR_INDEX.include?(color) }
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

class Game

  def initialize
    @round = Round.new
    @num_rounds = 0
    @user_game_selection = 0
  end

  # play a full 12-round game
  def play(game_version)
    if game_version == "guesser"
      solution = Code.new.create_random_code
    elsif game_version == "creator"
      solution = Code.new.get_user_code("solution")
    end
    while @round.num_exact_matches != 4 && @num_rounds < 12
      @num_rounds == 11 ? (puts "Last round!\n\n") : (puts "#{12 - @num_rounds} rounds left!\n\n")
      puts "Round #{@num_rounds + 1}:\n\n"
      if game_version == "guesser"
        @round.play(solution, "guesser")
      elsif game_version == "creator"
        puts "Computer guesses:"
        @round.play(solution, "creator")
      end
      @num_rounds += 1
      if game_version == "guesser"
        puts "12 rounds are up. You lose!\n\n" if @num_rounds == 12
        @round.did_user_win == true ? (puts "You win!\n\n") : (puts "Try again!\n\n")
      elsif game_version == "creator"
        puts "12 rounds are up. Computer loses!\n\n" if @num_rounds == 12
        puts "Press return to play another round\n\n" if @num_rounds < 12
        gets.chomp
        @round.did_user_win == true ? (puts "Computer wins!\n\n") : (puts "The End!\n\n")
      end
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