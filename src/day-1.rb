$nums = "one two three four five six seven eight nine".split " "

def toInt (s) 
    idx = $nums.find_index(s)
    idx ? idx + 1 : s
end

def getValue (line)
    first, *, last = line.scan(/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/).map{ |m| toInt(m[0]) }
    "#{first}#{last || first}".to_i
end

puts File.readlines("../inputs/day-1.txt").map { getValue(_1) }.sum
