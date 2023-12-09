require 'parallel'

def get_values(input)
    input.scan(/\d+/).map(&:to_i)
end

def parse(input)
    stack = input.lines.select.map(&:strip)
    seeds = []
    maps = {}
    while line = stack.shift
        case line
            when /^seeds:/
                seeds = get_values(line)
            when /map:$/
                name = line.match(/(.*) map:/).captures[0]
                maps[name] = []    
            when /(\d+\s+?)+/
                maps[maps.keys.last] << get_values(line)
        end
    end

    return seeds, maps
end

$map_types = ['soil', 'fertilizer', 'water', 'light', 'temperature', 'humidity', 'location']

def plant (input)
    seeds, maps = parse(input)
    locations = seeds.map do |seed|
        puts "seed #{seed}"
        map = maps['seed-to-soil']
        current = seed
        from_name = "seed"
        $map_types.each_with_index do |to_name, index|
            map = maps["#{from_name}-to-#{to_name}"]
            puts "#{from_name}-to-#{to_name} -> #{current} -> #{lookup(map, current)}"
            current = lookup(map, current)
            from_name = to_name
        end
        current
    end
    return locations.min
end

def lookup(map, input)
    map.each do |(dst, src, range)|
        if input >= src && input < src+range
            offset = input - src
            return target = dst + offset
        end
    end
    input
end

input = File.read('../inputs/day-5.txt')

p plant(input)

def in_range_for_maps (start, ln)
    seed_range = (start...start + ln)
    maps.any? do |(dst, src, range)|
        map_range = (src...src + range)
        seed_range.start >= map_range.start && seed_range.end <= map_range.end
    end
end

def plant_ranges (input)
    seeds, maps = parse(input)
    count = 0
    locations = Parallel.map(seeds.each_slice(2), in_processes: 16) do |(start, ln)|
        final_locations = []
        # return start if not in_range_for_maps(start, ln)
        for seed in start...(start+ln)
            print "\e[2J\e[f"
            puts "#{count+=1}"
            map = maps['seed-to-soil']
            current = seed
            from_name = "seed"
            $map_types.each_with_index do |to_name, index|
                map = maps["#{from_name}-to-#{to_name}"]
                # puts "#{from_name}-to-#{to_name} -> #{current} -> #{lookup(map, current)}"
                current = lookup(map, current)
                from_name = to_name
            end
            final_locations << current
        end
        final_locations.min
    end
    # p threads.each(&:join)
    return locations.min
end

p plant_ranges(input)