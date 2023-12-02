
def parse (game)
    id, value = game.match(/^Game (\d+): (.*)/).captures
    sets = value.split(';').map { |s| parse_set(s) }
    return id, sets
end

def parse_set(set)
    set.split(',').each_with_object({}) do |s, cubes|
        n, color = s.match(/(\d+) (red|green|blue)/).captures
        cubes[color.to_s] = n.to_i
    end
end

def is_possible_set (set, bag)
    ["red", "green", "blue"].all? do |color|
        set[color] == nil || set[color] <= bag[color]
    end
end

def is_possible_game (game)
    id, sets = parse(game)
    return sets.all? { |s| is_possible_set(s, $bag) } ? id : nil
end

$bag = { 'red' => 12, 'green' => 13, 'blue' => 14 }

p File.readlines("../inputs/day-2.txt").map { is_possible_game(_1) }.select.map(&:to_i).sum
