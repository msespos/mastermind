class Player

  @@COLOR_INDEX = ["red", "orange", "yellow", "green", "blue", "purple"]

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
    user_guesses.each do |color|
      if !@@COLOR_INDEX.include?(color)
        return false
      end
    end
    true
  end

  # request and obtain the user's guesses, reprompting until they are valid
  def get_guesses
    until length_correct?(@user_guesses) && colors_correct?(@user_guesses)
      puts <<~HEREDOC
        Please enter your guesses.
        Guess four colors from the following list, separated by commas:
        red, yellow, orange, green, blue, and purple
      HEREDOC
      @user_guesses = gets.chomp.downcase.split(/\s*,\s*/)
    end
  end

end

class Game

  @@COLOR_INDEX = ["red", "orange", "yellow", "green", "blue", "purple"]

  def initialize
    @user_guesses = Player.new.user_guesses
    @num_exact_matches = 0
    @num_white_pegs = 0
  end

  # identify the number of exact matches and store it in @num_exact_matches
  # change those matches to nil in preparation for find_white_matches
  def find_exact_matches(guesses, solution)
    exact_matches = guesses.zip(solution).map { |x, y| x == y }
    @num_exact_matches = exact_matches.count(true)
  end

  # get rid of all nil elements in the guesses and solution array
  # check for the number of white peg matches and store it in @num_white_pegs
  # change all matches to nil to avoid duplications
  def find_white_matches(guesses, solution)
    guesses.compact!
    solution.compact!
    guesses.each_with_index do |color, i|
      solution.each_with_index do |solution_color, j|
        if color == solution_color
          guesses[i] = nil
          solution[j] = nil
          @num_white_pegs += 1
        end
      end
    end
  end
  
  # transform an array of numbers to the corresponding COLOR_INDEX colors
  def translate_to_colors(solution)
    solution.each_with_index do |num, i|
      solution[i] = @@COLOR_INDEX[num]
    end
  end

  # call find_black_matches and find_white_matches, then report the results
  def play(solution)
    translate_to_colors(solution)
    p solution
    find_exact_matches(@user_guesses, solution)
    find_white_matches(@user_guesses, solution)
    display_score
  end

  def display_score
    if @num_exact_matches == 4
      puts "4 black pegs. You win!"
    elsif @num_exact_matches == 1 && @num_white_pegs == 1
      puts "1 black peg and 1 white peg. Try again!"
    elsif @num_exact_matches == 1 && @num_white_pegs != 1
      puts "1 black peg and #{@num_white_pegs} white pegs. Try again!"
    elsif @num_exact_matches != 1 && @num_white_pegs == 1
      puts "#{@num_exact_matches} black pegs and 1 white peg. Try again!"
    else
      puts "#{@num_exact_matches} black pegs and #{@num_white_pegs} white pegs. Try again!"
    end
  end

end

class Solution

  attr_reader :solution

  # create a randomized solution array
  def initialize
    @solution = []
    0.upto(3) { @solution.push(rand(6)) }
  end
  
end

game = Game.new
solution = Solution.new.solution
game.play(solution)