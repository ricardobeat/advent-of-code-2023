
$cards = %w[A K Q J T 9 8 7 6 5 4 3 2]
$hands = %w[five_of_a_kind four_of_a_kind full_house three_of_a_kind two_pair one_pair high_card]

CARD_REGEXP = /#{$cards.join('|')}/

def get_cards(hand)
    hand.scan(CARD_REGEXP)
end

def x_of(cards, n)
    groups = cards.group_by(&:itself).values.count { _1.size == n }
end

def five_of_a_kind(cards)
    x_of(cards, 5) >= 1
end

def four_of_a_kind(cards)
    x_of(cards, 4) >= 1
end

def full_house(cards)
    x_of(cards, 3) >= 1 and x_of(cards, 2) >= 1
end

def three_of_a_kind(cards)
    x_of(cards, 3) >= 1 and x_of(cards, 2) == 0
end

def two_pair(cards)
    x_of(cards, 2) >= 2
end

def one_pair(cards)
    x_of(cards, 2) == 1
end

def high_card(cards)
    cards.uniq.size == 5
end

def score(cards)
    $hands.each_with_index do |m, index|
        if method(m).call(cards)
            s = $hands.size - index - 1
            # puts "#{cards.join('')} => #{m} #{s}"
            return s
        end
    end
    # puts "#{cards.join('')} => 0"
    return 0
end

def parse(input)
    input.map do |line|
        hand, bid = line.split(' ').map(&:strip)
        cards = get_cards(hand)
        {:hand => hand, :cards => cards, :bid => bid.to_i, :score => score(cards)}
    end
end

def stronger(h1, h2)
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
        if sa > sb
            1
        elsif sa < sb
            -1
        else
            stronger(a[:hand], b[:hand])
        end
    end

    games.each do |g|
        p [g[:hand], g[:score]]
    end

    winnings = games.map.with_index { |g, i| g[:bid] * (i + 1) }
end

input = File.readlines('../test-inputs/day-7.txt')

games = parse(input)
p get_winnings(games).sum
