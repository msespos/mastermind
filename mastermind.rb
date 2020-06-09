class Player
end

class Game

  @@COLOR_INDEX = ["red", "orange", "yellow", "green", "blue", "purple"]

  def initialize
    @user_guesses = []
    @num_black_pegs = 0
    @num_white_pegs = 0
  end

  def length_correct?(user_guesses)
    user_guesses.length == 4
  end

  def colors_correct?(user_guesses)
    user_guesses.each do |color|
      if !@@COLOR_INDEX.include?(color)
        return false
      end
    end
    true
  end

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
  
  def find_black_matches(solution)
    @user_guesses.each_with_index do |color, i|
      if color == solution[i]
        @num_black_pegs += 1
        @user_guesses[i] = nil
        solution[i] = nil
      end
    end
    solution
  end

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
  
  def find_matches(solution)
    black_matches_nil_solution = find_black_matches(solution)
    find_white_matches(@user_guesses, black_matches_nil_solution)
    if @num_black_pegs == 4
      puts "4 black pegs. You win!"
    elsif @num_black_pegs == 1 && @num_white_pegs == 1
      puts "1 black peg and 1 white peg. Try again!"
    elsif @num_black_pegs == 1 && @num_white_pegs != 1
      puts "1 black peg and #{@num_white_pegs} white pegs. Try again!"
    elsif @num_black_pegs != 1 && @num_white_pegs == 1
      puts "#{@num_black_pegs} black pegs and 1 white peg. Try again!"
    else
      puts "#{@num_black_pegs} black pegs and #{@num_white_pegs} white pegs. Try again!"
    end
  end

end

class Solution

  @@COLOR_INDEX = ["red", "orange", "yellow", "green", "blue", "purple"]
 
  attr_reader :solution

  def initialize
    @solution = []
    0.upto(3) { @solution.push(rand(6)) }
    @solution.each_with_index do |num, i|
      @solution[i] = @@COLOR_INDEX[num]
    end
    p @solution
  end
  
end

game = Game.new
solution = Solution.new.solution
game.get_guesses
game.find_matches(solution)