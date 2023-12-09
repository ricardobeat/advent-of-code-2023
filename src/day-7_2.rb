
$cards = %w[A K Q J T 9 8 7 6 5 4 3 2]
$hands = %w[five_of_a_kind four_of_a_kind full_house three_of_a_kind two_pair one_pair high_card]

$joker = false

def add_joker
    $joker = true
    j = $cards.find_index("J")
    $cards.delete_at(j)
    $cards << "J"
end

CARD_REGEXP = /#{$cards.join('|')}/

def get_cards(hand)
    hand.scan(CARD_REGEXP)
end

class Hand
    def initialize(cards)
        @cards = cards
        group_cards
    end

    def group_cards
        if $joker
            jokers, cards = @cards.partition { _1 == "J" }
        else
            jokers, cards = [[], @cards]
        end
        groups = cards.group_by(&:itself).values.sort_by(&:size).reverse
        groups = [[]] if groups.size == 0
        if jokers.size > 0
            groups.first << jokers.pop while jokers.size > 0 && groups.first.size < 5
        end
        @groups = groups.map(&:size)
    end

    def score
        return case
        when @groups.include?(5) then 50
        when @groups.include?(4) then 40
        when @groups.include?(3) && @groups.include?(2) then 32
        when @groups.include?(3) then 30
        when @groups.count(2) >= 2 then 20
        when @groups.count(2) == 1 then 10
        else 0
        end
    end
end

def score(cards)
    hand = Hand.new(cards)
    hand.score
end

def solve(input)
    input.map do |line|
        hand, bid = line.split(' ').map(&:strip)
        score = Hand.new(get_cards(hand)).score
        {:hand => hand, :bid => bid.to_i, :score => score}
    end
end

def best_hand(h1, h2)
    for i in 0...h1.size
        ia = $cards.find_index(h1[i])
        ib = $cards.find_index(h2[i])
        return 1 if ia < ib
        return -1 if ib < ia
    end
    return 0
end

def get_winnings(games)
    games.sort! do |a, b|
        sa = a[:score]
        sb = b[:score]
        if sa > sb then 1
        elsif sa < sb then -1
        else best_hand(a[:hand], b[:hand])
        end
    end

    # games.each do |g|
    #     puts "#{g[:hand]} #{g[:score]}"
    # end

    winnings = games.map.with_index { |g, i| g[:bid] * (i + 1) }
end

input = File.readlines('../inputs/day-7.txt')

games = solve(input)
p get_winnings(games).sum

add_joker

games = solve(input)
p get_winnings(games).sum
