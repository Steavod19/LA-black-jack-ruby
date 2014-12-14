#!/usr/bin/env ruby

require 'pry'

SUITS = ['♠', '♣', '♥', '♦']
RANKS = [ 2, 3, 4, 5, 6, 7, 8, 9, "A", "J", "Q", "K"]

class Card
  attr_reader :suit, :rank
  def initialize (suit, rank)
    @suit = suit
    @rank = rank
  end

  def face_card?
    ["J", "Q", "K"].include?(@rank)
  end

  def ace?
    ["A"].include?(@rank)
  end
end

class Deck
  attr_reader :deck
  def initialize

    @deck = []
    SUITS.each do |suit|
      RANKS.each do |rank|
        @deck << Card.new(suit, rank)
      end
    end
    @deck.shuffle!
  end

  def draw_card
    @deck.pop
  end
end

class Hand
  attr_accessor :value, :cards

  def initialize
    @cards = []
    @dealer =[]
  end

  def draw(card)
    @cards << card
    puts "Player dealt #{card.rank} #{card.suit}"
  end

  def draw_dealer(card)
    @dealer << card
    puts "Dealer dealt #{card.rank} #{card.suit}"
  end

  def value_of_hand
    @value = []
    @cards.each do |card|
      if card.face_card?
        @value << 10
      elsif card.ace?
        @value << 0
      else
        @value << card.rank
      end
    end
    if @value.include?(0)
      if @value.inject(:+).to_i <= 10
        @value.each do |num|
          if num == 0
            @value << 11
          end
        end
      else
        @value.each do |num|
          if num == 0
            @value << 1
          end
        end
      end
    end

    @value = @value.inject(:+).to_i
  end

  def d_value_of_hand
    @value = []
    @dealer.each do |card|
      if card.face_card?
        @value << 10
      elsif card.ace?
        @value << 0
      else
        @value << card.rank
      end
    end

    if @value.include?(0)
      if @value.inject(:+).to_i <= 10
        @value.each do |num|
          if num == 0
            @value << 11
          end
        end
      else
        @value.each do |num|
          if num == 0
            @value << 1
          end
        end
      end
    end

    @value = @value.inject(:+).to_i

  end
end

#new array with shuffled deck
deck = Deck.new

puts "Welcome to BlackJack!\n\n"



#intital draw
player = Hand.new
player.draw(deck.draw_card)
player.draw(deck.draw_card)
puts "Player score: #{player.value_of_hand}\n"


#game play
until player.value_of_hand >= 21
  print "\nHit or Stand (H/S):"
  answer = gets.chomp.downcase
  if answer == "h"
    player.draw(deck.draw_card)
    puts "Player score: #{player.value_of_hand}\n"
  elsif answer == "s"
    break
  else
    puts "Please enter \"H\" or \"S\""
  end
end

if player.value_of_hand > 21
  puts "Bust! You lose..."
else
  puts "\nPlayer Stands\n\n"
  dealer = Hand.new
  dealer.draw_dealer(deck.draw_card)
  dealer.draw_dealer(deck.draw_card)

  until dealer.d_value_of_hand >=17
    dealer.draw_dealer(deck.draw_card)
  end

  puts "Dealer score: #{dealer.d_value_of_hand}\n"

  if dealer.d_value_of_hand >= 22
    puts "You Win!"
  elsif dealer.d_value_of_hand <= 21
    puts "Dealer stands."
    if dealer.d_value_of_hand < player.value_of_hand
      puts "You Win!"
    elsif dealer.d_value_of_hand > player.value_of_hand
      puts "Dealer Wins."
    else
      puts "Push."
    end
  end
end
