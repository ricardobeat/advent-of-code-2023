import { readFileSync } from "fs";

const getNumbers = (s: string) => {
  let numbers = s.trim().split(/\s+/);
  return numbers.map((s) => s.trim());
};

function count(input: string[]) {
  return input.reduce((total, line) => {
    let [winning, mine] = line.split(":")[1].split("|").map(getNumbers);
    let score = mine.filter((n) => winning.includes(n)).length;
    return score ? total + Math.pow(2, score - 1) : total;
  }, 0);
}

let input = readFileSync("../inputs/day-4.txt", "utf8").split(/\n/);

console.log(count(input));
