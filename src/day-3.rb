require 'strscan'

input = File.read("../inputs/day-3.txt")

symbols = []

def scan_around (lines, row, col)
    matches = []
    for cr in row-1..row+1 do
        for cc in col-1..col+1 do
            target = lines[cr] && lines[cr][cc]
            if target && target.match(/[0-9]/)
                cc -= 1 while cc > 0 && lines[cr][cc - 1] =~ /\d/
                matches << [cr, cc]
            end
        end
    end
    matches.uniq.map { |(py, px)| lines[py][px..][/\d+/].to_i }
end

def find_parts(input, search = nil)
    lines = input.lines
    found = []
    lines.each_with_index do |line, row|
        s = StringScanner.new(line.strip)
        while s.skip_until(/[^.\d]/)
            next if !search.nil? and s.matched != search # part 2
            if parts = scan_around(lines, row, s.pos - 1)
                found.push parts
            end
        end
    end
    return found
end

puts find_parts(input).flatten.sum

puts find_parts(input).select { _1.size == 2 }.map {|set| set.reduce(:*) }.sum
