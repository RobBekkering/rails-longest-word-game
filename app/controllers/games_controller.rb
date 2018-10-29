require 'open-uri'

class GamesController < ApplicationController
  def new
    @grid = []
    10.times { @grid << ("A".."Z").to_a.sample }
  end

  def score
    @result = {score: "", message: "" }
    if correct_word?(params[:guess]) && same_letters?(params[:guess], params[:grid])
      @result[:message] = "Well done!"
      @result[:score] = (params[:guess].length * 100) - ( Time.now - params[:start_time].to_datetime).to_i
    elsif !correct_word?(params[:guess])
      @result[:message] = "Not an english word"
    else
      @result[:message] = "That's not in the grid.."
    end
  end

  def same_letters?(guess, grid)
    grid_array = grid.downcase.split(" ")
    counter = 0
    guess.downcase.chars.each do |letter|
      if grid_array.detect{ |grid_letter| grid_letter == letter}
        grid_array.delete(letter)
        counter += 1
      end
    end
    guess.length == counter
  end

  def correct_word?(attempt)
    attempt_serialized = open("https://wagon-dictionary.herokuapp.com/#{attempt}").read
    attempt_hash = JSON.parse(attempt_serialized)
    attempt_hash["found"]
  end
end
