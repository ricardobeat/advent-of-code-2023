
input = File.readlines('../inputs/day-8.txt').map(&:strip)

directions = input.shift.split("")
input.shift

def get_map(input)
    input.inject({}) do |map, line|
        from, left, right = line.scan(/\w+/)
        map[from] = { "L"=> left, "R" => right }
        map
    end
end

def solve(pos, map, directions)
    steps = 0
    directions.cycle do |direction|
        steps += 1
        # puts "#{pos} #{direction}, #{map[pos]}"
        pos = map[pos][direction]
        break if pos.end_with? "Z"
    end
    steps
end

map = get_map(input)
p solve("AAA", map, directions)

ghosts = map.keys.select { |k| k =~ /A$/ }
p ghosts.map { |ghost| solve(ghost, map, directions) }.reduce(1, :lcm)
