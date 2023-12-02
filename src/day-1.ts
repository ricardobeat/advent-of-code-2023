import { readFileSync } from "fs"

const input = readFileSync("../inputs/day-1.txt", 'utf-8')

export function getValue (input: string) {
    const [first, ...rest] = (input.match(/\d/g) || []) as string[]
    const last = rest[rest.length - 1] || first
    return +(first + last)
}

const result = input.trim().split(/\n/).map(line => getValue(line)).reduce((p,c) => p + c, 0)

console.log(result)

// ----------------------------------------------------------------------------
// part 2

const digits = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
const exp = new RegExp(`\\d|(?=(${digits.join('|')}))`, 'g')

function toNumber (digit: string)  {
    const index = digits.indexOf(digit)
    return index >= 0 ? (index+1).toString() : digit
}

export function getValue2 (input: string) {
    let [first, ...rest] = (input.matchAll(exp) || []) as string[]
    let last = rest[rest.length - 1] || first
    first = first[0] || first[1]
    last = last[0] || last[1]
    return +[first, last].map(toNumber).join('')
}

const result2 = input.trim().split(/\n/).map(line => getValue2(line)).reduce((p,c) => p + c, 0)

console.log(result2)