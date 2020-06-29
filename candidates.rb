class Candidates

  require_relative 'colors.rb'
  include Colors

  attr_reader :candidates

  def initialize
    @candidates = (1111..6666).to_a
    @candidates.map! { |code| code.to_s.split(//) }
    @candidates.each { |code| code.map! { |color| color.to_i } }
    @candidates.delete_if { |code| code.any? {|color| color > 6 || color == 0} }
    @candidates.each_with_index do |code, i|
      code.each_with_index do |color, j|
        @candidates[i][j] = @@COLOR_LIST[color - 1]
      end
    end
  end

  def filter_candidates(non_matches)
    @candidates = @candidates - non_matches
  end

end