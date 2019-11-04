require "open-uri"
require "json"

class GamesController < ApplicationController

  # some sort of variable that is initialized when the game start
  @@points = 0

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @attempt = params[:attempt].downcase
    @letters = params[:letters].downcase
    @word_in_letters = test_chars(@letters, @attempt)


    if @word_in_letters
      @is_english_word = english_word?(@attempt)
    end

    if @is_english_word
     @@points += @attempt.length
     @points = @@points
    end

  end

  def test_chars(letters, attempt)
    attempt.chars.all? { |char| letters.include?(char) }
  end

  def english_word?(attempt)
    response = open("https://wagon-dictionary.herokuapp.com/#{attempt}")
    json = JSON.parse(response.read)
    return json['found']
  end

  # {"found":false,"word":"carawsa","error":"word not found"}
  # {"found":true,"word":"car","length":3}
end
