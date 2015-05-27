module UserResponses
  def num_of_players
    begin
      puts "How many people want to play? (max 5)"
      answer = gets.chomp
    end until ((1..5).include?(answer.to_i))
  end

  def get_players_names(num)
    players = []
    num_players.times do |num|
      puts "Please enter name of #{num+1}:"
      players[name] = gets.chomp
    end
    players
  end

  def hit_or_stay
    begin
      print "==> do you want to (h)it or (s)tay? "
      answer = gets.chomp.downcase
    end until (['h','s'].include?(answer))
    answer
  end
end

class Card
  FACE_CARD = ['Jack','Queen','King','Ace']
  attr_accessor :suit, :value

  def initialize(s,v)
    self.suit = s
    self.value = v
  end

  def is_a_face_card?
    FACE_CARD.include?(value) ? true : false
  end

  def to_s
    " |#{value} of #{suit}| "
  end
end

module HandValue
  def value_of_hand(cards_in_hand)
    value = 0
    cards_in_hand.each do |card|
      if card.is_a_face_card? #is this a face card?
        if card.value =='Ace'
          value = value + 11
        else
          value = value + 10
        end
      else
        value = card.value.to_i + value
      end
    end
    # Set value of Ace in hand to 1 if previous value of 11 causes bust
    value = value - 10 if (value>21 && includes_Ace?(cards_in_hand))
    value
  end

  def includes_Ace?(cards)
    cards.each {|card| return true if card.value == 'Ace'}
    false
  end
end

class Hand
  include HandValue
  attr_accessor :value, :cards

  def initialize
    self.value = 0
    self.cards= []
  end

  def add_a_card(card)
    cards << card
  end

  def total_value
    self.value = value_of_hand(cards)
  end

  def show_hand
    cards.each {|c| print c }
  end

  def show_value
    puts "====> Total: #{value}"
  end
end

class Deck
  SUITS = ['Hearts', 'Spades', 'Clubs','Diamonds']
  CARDS = ['2','3','4','5','6','7','8','9','10','Jack','Queen','King','Ace']
  attr_accessor :cards

  def initialize(num_of_decks)
    self.cards = []
    SUITS.each do |suit|
      CARDS.each do |value|
        self.cards << Card.new(suit,value)
      end
    end
    self.cards = cards*num_of_decks
    shuffle_deck!
  end

  def shuffle_deck!
    cards.shuffle!
  end

  def deal_a_card
    cards.pop
  end
end

class Player
  attr_accessor :name, :hand

  def initialize(n)
    self.name = n
    self.hand = Hand.new
  end

  def to_s
    "#{name}:"
  end
end

class Dealer
  attr_accessor :name, :hand

  def initialize
    self.hand = Hand.new
    self.name = "Dealer"
  end

  def to_s
    "Dealer:"
  end
end

class Blackjack
  include UserResponses
  attr_accessor :player, :dealer, :deck

  def initialize(num_of_decks)
    self.player = Player.new("Gigi")
    self.dealer = Dealer.new
    self.deck = Deck.new(num_of_decks)
  end

  def play_a_hand(player,stop_value)
    puts "----------------  #{player.name}'s Hand ----------------"
    player.hand.add_a_card(deck.deal_a_card)
    # deal player's hand until he 'stays', reaches 21 or busts
    while (player.hand.total_value < stop_value)
      # deal a card, value and display hand
      print player
      player.hand.add_a_card(deck.deal_a_card)
      player.hand.total_value
      player.hand.show_hand
      player.hand.show_value

      # ask if player (not dealer) wants another card if hand is less than 21
      if (player.hand.total_value<21 && player.name != 'Dealer')
        break if hit_or_stay=='s'
      end
    end
  end

  def play_game
    play_a_hand(player,21)
    play_a_hand(dealer,17)
    find_winner
  end

  def find_winner
    puts "----------------  and the winner is... ----------------"
    if (dealer.hand.total_value == 21) then
      puts "Blackjack! Dealer wins."
      exit
    elsif ((dealer.hand.total_value > player.hand.total_value && dealer.hand.total_value <21) || player.hand.total_value >21)
      puts "Sorry, #{player.name}. You lose."
    else
      puts "#{player.name} wins!"
    end
  end
end

Blackjack.new(1).play_game
