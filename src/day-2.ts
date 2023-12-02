import { readFileSync } from "fs";

let input = readFileSync("../inputs/day-2.txt", 'utf-8')

type Cubes = {
    [color: string]: number;
}

const bag: Cubes = {
    red: 12,
    green: 13,
    blue: 14
}

function parseValues (s: string): Cubes {
    return s.split(',').reduce((p,c) => {
        let [count] = c.match(/\d+/)
        let [color] = c.match(/red|green|blue/)
        p[color] = +count
        return p
    }, {})
}

function parseSets (game: string) {
    let [_, s] = game.split(':')
    return s.split(";").map(s => parseValues(s))
}

function isPossibleSet(set: Cubes, bag: Cubes) {
    return Object.keys(set).every(key => {
        return set[key] <= bag[key]
    })
}

function fewestPossibleCubes(sets: Cubes[]) {
    let max : Cubes = {
        red: 0,
        green: 0,
        blue: 0
    }
    sets.forEach(set => {
        for (let key in set) {
            max[key] = Math.max(max[key], set[key])
        }
    })
    return max
}

function getPower(set: Cubes) {
    return set.red * set.green * set.blue
}

let possibleGames = input.split(/\n/).reduce((sum, game, i) => {
    let n = i+1
    let sets = parseSets(game)
    let isPossible = sets.every(set => isPossibleSet(set, bag))
    return isPossible ? sum + n : sum
}, 0)

let totalPower = input.split(/\n/).reduce((p, game) => {
    let sets = parseSets(game)
    let min = fewestPossibleCubes(sets)
    return p + getPower(min)
}, 0)

console.log(possibleGames, totalPower)