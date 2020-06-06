@COLOR_INDEX = ["red", "orange", "yellow", "green", "blue", "purple"]

@computer_solution = []
@user_guesses = []
@num_black_pegs = 0
@num_white_pegs = 0

def create_solution
  0.upto(3) {@computer_solution.push(rand(6))}
  @computer_solution.each_with_index do |num, i|
    @computer_solution[i] = @COLOR_INDEX[num]
  end
  p @computer_solution
end

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

create_solution
get_guesses