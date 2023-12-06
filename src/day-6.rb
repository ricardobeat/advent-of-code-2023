input = File.readlines("../inputs/day-6.txt")

def race(speed, time, distance)
    speed * (time - speed)
end

def count_wins(time, distance)
    (0..time).sum { |s| race(s, time, distance) > distance ? 1 : 0 }
end

times, distances = input.map{ _1.scan(/\d+/).to_a.map(&:to_i) }
races = times.map.with_index { |time, i| [time, distances[i]] }

p races.map {|(t, d)| count_wins(t, d)}.reduce(&:*)

def count_wins_range(time, distance)
    lower_bound = (0..time).bsearch { |i| race(i, time, distance) > distance }
    upper_bound = (lower_bound..time).bsearch { |i| race(i, time, distance) < distance }
    return upper_bound - lower_bound
end

time, distance = input.map{ _1.scan(/\d+/).to_a.join('').to_i }

p count_wins_range(time, distance)
