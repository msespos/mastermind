class Code

  require_relative 'colors.rb'
  include Colors

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