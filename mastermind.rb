require 'colorize'

class Player

  @@COLOR_INDEX = ["r", "y", "g", "c", "b", "m"]

  attr_reader :user_guesses

  def initialize
    @user_guesses = []
    get_guesses
  end
  
  # check that the user submits exactly four colors
  def length_correct?(user_guesses)
    user_guesses.length == 4
  end

  # check that the user submits only valid colors
  def colors_correct?(user_guesses)
    user_guesses.all? { |color| @@COLOR_INDEX.include?(color) }
  end

  # request and obtain the user's guesses, reprompting until they are valid
  def get_guesses
      #  #{" ".on_light_red + " " + " ".on_light_yellow + " " + " ".on_light_green +
      #  " " + " ".on_light_cyan + " " + " ".on_light_blue + " " + " ".on_light_magenta}
    puts <<~HEREDOC
        Guess four colors from the following list
        #{"red".light_red}, #{"yellow".light_yellow}, #{"green".light_green}, \
        #{"cyan".light_cyan}, #{"blue".light_blue}, and #{"magenta".light_magenta}
        Use the first letter of each color (in lower case) for your guess
        e.g. rygc
              
      HEREDOC
    until length_correct?(@user_guesses) && colors_correct?(@user_guesses)
      puts "Please enter your four guesses."
      @user_guesses = gets.chomp.downcase.split("")
    end
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

class Solution

  @@COLOR_INDEX = ["r", "y", "g", "c", "b", "m"]

  attr_reader :solution

  # create a randomized solution array
  def initialize
    @solution = []
    0.upto(3) { @solution.push(rand(6)) }
    translate_to_colors(@solution)
  end
  
  # transform an array of numbers to the corresponding COLOR_INDEX colors
  def translate_to_colors(solution)
    solution.each_with_index { |num, i| solution[i] = @@COLOR_INDEX[num] }
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

game = Game.new
game.play