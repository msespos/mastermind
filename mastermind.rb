def Player
end

def Game

  @COLOR_INDEX = ["red", "orange", "yellow", "green", "blue", "purple"]

  @user_guesses = []
  @num_black_pegs = 0
  @num_white_pegs = 0

  def get_guesses
    puts "Enter your four guesses, separated by commas"
    @user_guesses = gets.chomp.split(/\s*,\s*/)
    @user_guesses.each do |color|
      while !@COLOR_INDEX.include? color
        puts "Please enter 4 colors from the following list:"
        puts "red, yellow, orange, green, blue, and purple"
        @user_guesses = gets.chomp.split(/\s*,\s*/)
      end
    end
    p @user_guesses
  end
  
  def find_black_matches
    @user_guesses.each_with_index do |color, i|
      if color == @computer_solution[i]
        @num_black_pegs += 1
        @user_guesses[i] = nil
      end
    end
    p @num_black_pegs
    p @user_guesses
  end

end

def Sequence

  @computer_solution = []

  def initialize
    0.upto(3) {@computer_solution.push(rand(6))}
    @computer_solution.each_with_index do |num, i|
      @computer_solution[i] = @COLOR_INDEX[num]
    end
    p @computer_solution
  end
  
end