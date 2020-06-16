require 'colorize'

class Player

  attr_reader :user_guesses

  def initialize
    @user_guesses = []
    get_guesses
  end

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

  def display_score
    display_guesses(@user_guesses)
    if @num_exact_matches == 4
      @did_user_win = true
      puts (" ".on_black + " ") * 4 + "\n\n"
      puts "4 exact matches.\n\n"
    elsif @num_exact_matches == 1 && @num_color_only_matches == 1
      puts " ".on_black + " " + " ".on_white + "\n\n"
      puts "1 exact match and 1 color-only match.\n\n"
    elsif @num_exact_matches == 1 && @num_color_only_matches != 1
      puts " ".on_black + " " + (" ".on_white + " ") *
          @num_color_only_matches + "\n\n"
      puts "1 exact match and #{@num_color_only_matches} "\
          "color-only matches.\n\n"
    elsif @num_exact_matches != 1 && @num_color_only_matches == 1
      puts (" ".on_black + " ") * @num_exact_matches +
          " ".on_white + "\n\n"
      puts "#{@num_exact_matches} exact matches and 1 color-only match.\n\n"
    else
      puts (" ".on_black + " ") * @num_exact_matches + 
          (" ".on_white + " ") * @num_color_only_matches + "\n\n"
      puts "#{@num_exact_matches} exact matches and "\
          "#{@num_color_only_matches} color-only matches.\n\n"
    end
  end

  # play a round
  def play(solution)
    p solution
    @user_guesses = Player.new.user_guesses
    find_exact_matches(@user_guesses, solution)
    find_color_only_matches(@user_guesses, solution)
    display_score
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
    pick = type == "guess" ? "Guess" : "Select"
    choice = type == "guess" ? "guess" : "selection"
    puts <<~HEREDOC
      #{pick} four colors from the following list
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
  def get_user_code
    user_code = []
    until length_correct?(user_code) && colors_correct?(user_code)
      puts "Please enter your four guesses."
      user_code = gets.chomp.downcase.split("")
    end
    user_code
  end

end

class Game

  def initialize
    @round = Round.new
    @num_rounds = 0
    @solution = Solution.new.solution
  end

  # play a full 12-round game
  def play
    while @round.num_exact_matches != 4 && @num_rounds < 12
      @num_rounds == 11 ? (puts "Last round!\n\n") : (puts "#{12 - @num_rounds} rounds left!\n\n")
      puts "Round #{@num_rounds + 1}:\n\n"
      @round.play(@solution)
      @num_rounds += 1
      puts "12 rounds are up. You lose!\n\n" if @num_rounds == 12
      @round.did_user_win == true ? (puts "You win!\n\n") : (puts "Try again!\n\n")
    end
  end

end

class Intro

  def initialize
    @user_selection = 0
  end

  def display_intro
    puts <<~HEREDOC

      Welcome to Mastermind!
      Would you like to be the guessor or the creator of the secret code?
      Enter 1 to be the guesser
      Enter 2 to be the creator

    HEREDOC
  end

  def get_user_selection
    until @user_selection == "1" || @user_selection == "2"
      puts "Please enter 1 or 2"
      @user_selection = gets.chomp
      puts "\n"
    end
  end

  def begin_game
    if @user_selection == "1"
      game = Game.new
      game.play
    elsif @user_selection == "2"
      puts "(will go to player-creator game at this point)"
    end
  end

  def start
    display_intro
    get_user_selection
    begin_game
  end

end

intro = Intro.new
intro.start