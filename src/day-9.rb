
input = File.readlines('../inputs/day-9.txt')
readings = input.map { |l| l.split.map(&:to_i) }

def get_steps(values)
    steps = [values.clone]
    loop do
        deltas = []
        steps.last.each_cons(2) { |(a,b)| deltas << b - a }
        steps << deltas
        break if deltas.all? { |d| d == 0 }
    end
    steps
end

def get_predictions(readings)
    readings.map do |values|
        steps = get_steps(values)
        steps.reverse.each_cons(2) do |step, parent|
            next_value = parent.last + step.last
            parent << next_value
        end
        steps[0].last
    end.sum
end

p get_predictions(readings)
p get_predictions(readings.map(&:reverse))