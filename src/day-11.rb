def expand_galaxy(map)
    expanded = map.clone.map(&:clone)

    offset = 0
    map.each_with_index do |row, index|
        if row.all? { |cell| cell == '.' }
            offset += 1
            expanded.insert(index + offset, row.clone)
        end
    end

    offset = 0
    map[0].each_with_index do |col, index|
        if map.all? { |row| row[index] == '.' }
            offset += 1
            expanded.each { |row| row.insert(index + offset, "_") }
        end
    end

    expanded
end

def find_stars(map)
    stars = []
    map.each_with_index.map do |row, y|
        row.each_with_index.map do |cell, x|
            stars << [x,y] if cell == "#"
        end
    end
    stars
end

def pretty_print(map)
    map.each { |row| puts row.join('') }
end

def get_distance(a, b)
    ax, ay = a
    bx, by = b
    return (ax - bx).abs + (ay - by).abs
end

def part1(input)
    expanded = expand_galaxy(input)
    stars = find_stars(expanded)

    stars.each_with_index do |(x, y), index|
        expanded[y][x] = index + 1
    end
    
    total = 0
    stars.combination(2).each_with_index do |(s1, s2), index|
        distance = get_distance(s1, s2)
        n1 = expanded[s1[1]][s1[0]]
        n2 = expanded[s2[1]][s2[0]]
        puts "#{index}: #{n1} -> #{n2}: #{distance}"
        total += distance
    end

    pretty_print(expanded)

    p total
end

input = File.readlines("../inputs/day-11.txt").map { _1.strip.split('') }
part1(input)
