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
      puts "Please enter your guesses"
      puts "Guess four colors from the following list, separated by commas:"
      puts "red, yellow, orange, green, blue, and purple"
      @user_guesses = gets.chomp.downcase.split(/\s*,\s*/)
    end
  end
  
  def find_black_matches(solution)
    @user_guesses.each_with_index do |color, i|
      if color == solution[i]
        @num_black_pegs += 1
        @user_guesses[i] = nil
      end
    end
    p @user_guesses
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
game.get_guesses
game.find_black_matches(Solution.new.solution)