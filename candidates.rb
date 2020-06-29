class Candidates

  require_relative 'colors.rb'
  include Colors

  attr_reader :candidate_list

  def initialize
    @candidate_list = (1111..6666).to_a
    @candidate_list.map! { |code| code.to_s.split(//) }
    @candidate_list.each { |code| code.map! { |color| color.to_i } }
    @candidate_list.delete_if { |code| code.any? {|color| color > 6 || color == 0} }
    @candidate_list.each_with_index do |code, i|
      code.each_with_index do |color, j|
        @candidate_list[i][j] = @@COLOR_LIST[color - 1]
      end
    end
  end

  def remove_non_matches(non_matches)
    @candidate_list -= non_matches
  end

end