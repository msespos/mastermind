class Round

  require_relative 'colors.rb'
  include Colors

  attr_reader :num_exact_matches, :num_color_only_matches, :win_state, :score

  def initialize
    @exact_matches = []
    @num_exact_matches = 0
    @color_only_matches = []
    @num_color_only_matches = 0
    @win_state = false
    @score = []
  end

  #determine score of round from exact and color-only matches
  def score
    @score = [@num_exact_matches, @num_color_only_matches]
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
      @color_only_matches = (remaining_guesses | remaining_solution).flat_map do |entry|
        [entry] * [remaining_guesses.count(entry), remaining_solution.count(entry)].min
      end
    else
      @color_only_matches = []
    end
    @num_color_only_matches = @color_only_matches.length
  end

  # update the computer's guesses each round based on previous results
  def update_computer_guesses(computer_guesses, num_rounds, solution)
    if num_rounds == 0
      @computer_guesses = Code.new.create_random_code
    else
      @computer_guesses.each_with_index do |guess, i|
        @computer_guesses[i] = @@COLOR_LIST.sample if guess != solution[i]
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
    num_exact_matches == 4 ? @win_state = true : @win_state = false
    board_update = [guesses, [@num_exact_matches, @num_color_only_matches]]
  end

end