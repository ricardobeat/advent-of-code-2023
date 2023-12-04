def count_matches (input)
    id, value = input.match(/Card\s+(\d+): (.*)/).captures
    winning, mine = value.split("|").map{ _1.strip.split(" ").map(&:strip) }
    winning.count { |n| mine.include?(n) }
end

$cards = File.readlines('../inputs/day-4.txt')

p $cards.map{ count_matches(_1) }.select { _1 > 0 }.map{ 2 ** (_1 - 1) }.sum

def multiply_cards
    stack = Hash[(0...$cards.size).to_a.map { [_1, 1] } ]
    for i in 0...$cards.size
        stack[i].times do
            if n = count_matches($cards[i])
                for j in (i+1)..(i+n)
                    stack[j] += 1
                end
            end
        end
    end
    return stack.values.sum
end

p multiply_cards
