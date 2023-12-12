
VOID_ROW = "+"
VOID_COL = "-"
GROWTH_RATE = 1_000_000 - 1

def expand_galaxy(map)
    expanded = map.clone.map(&:clone)

    offset = 0
    map.each_with_index do |row, index|
        if row.all? { |cell| cell == '.' }
            offset += 1
            expanded.insert(index + offset, Array.new(row.length, VOID_ROW))
        end
    end

    offset = 0
    map[0].each_with_index do |col, index|
        if map.all? { |row| row[index] == '.' }
            offset += 1
            expanded.each do |row|
                row.insert(index + offset, row[0] == VOID_ROW ? VOID_ROW : VOID_COL)
            end
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

def get_distance(galaxy, a, b)
    ax, ay = a
    bx, by = b

    delta_x = (ax - bx).abs
    delta_y = (ay - by).abs

    low_x, high_x = [ax, bx].minmax
    low_y, high_y = [ay, by].minmax

    for x in (low_x..high_x)
        delta_x += GROWTH_RATE - 1 if galaxy[ay][x] == VOID_COL
    end

    for y in (low_y..high_y)
        delta_y += GROWTH_RATE - 1 if galaxy[y][ax] == VOID_ROW
    end

    return delta_x + delta_y
end

def part2(input)
    expanded = expand_galaxy(input)
    stars = find_stars(expanded)
    stars.combination(2).inject(0) do |sum, pair|
        sum + get_distance(expanded, *pair)
    end
end

input = File.readlines("../inputs/day-11.txt").map { _1.strip.split('') }
puts part2(input)
