import { readFileSync, writeFileSync } from "fs";

let input = readFileSync("../inputs/day-3.txt", "utf-8");

let DEBUG = process.env.DEBUG || false;

function part1() {
  let lines = input.trim().split(/\n/);
  let parts = [];

  lines.forEach((line, lineIndex) => {
    let matches = line.matchAll(/\d+/g);
    let prev = lines[lineIndex - 1];
    let next = lines[lineIndex + 1];

    for (let match of matches) {
      let partNumber = match[0];
      let start = match.index;
      let end = match.index + partNumber.length;
      if (findSymbol(line, start, end) || findSymbol(prev, start, end) || findSymbol(next, start, end)) {
        parts.push(+partNumber);
      }
    }
  });

  return parts;
}

function findSymbol(line: string | undefined, start: number, end: number) {
  if (!line) return false;
  for (let i = Math.max(0, start - 1); i <= end && line[i]; i++) {
    if (/[^.\d]/.test(line[i])) {
      return true;
    }
  }
}

console.log(part1().reduce((p, c) => p + c, 0));

function isDigit(s: string) {
  return /\d/.test(s);
}

let foundGears = {};
let foundNumbers = {};

function getNumberAt(index: number, s: string) {
  return +s.substring(index, s.length).match(/\d+/)?.[0];
}

function unique(parts: Array<number[]>) {
  return [...new Set(parts.map((p) => p.join(":")))].map((p) => p.split(":").map(Number));
}

function part2() {
  let lines = input.trim().split(/\n/); //.slice(0, 3);
  let lineLength = lines[0].length;
  let ratios = [];

  for (let y = 0; y < lines.length; y++) {
    let line = lines[y];
    DEBUG && console.log(line);

    for (let x = 0; x <= lineLength; x++) {
      if (line[x] != "*") {
        continue;
      }

      DEBUG && console.log("* at %d:%d", y, x);

      let parts = [];

      nextline: for (let cy of [y - 1, y, y + 1]) {
        for (let cx of [x - 1, x, x + 1]) {
          DEBUG && console.log("%d:%d", cy, cx);
          if (cx < 0 || cx >= lineLength || cy < 0 || cy >= lines.length) {
            continue;
          }

          if (!isDigit(lines[cy][cx])) {
            continue;
          }

          // find beginning of part number
          while (cx > 0 && isDigit(lines[cy][cx - 1])) {
            cx -= 1;
          }

          let number = getNumberAt(cx, lines[cy]);

          parts.push([cy, cx]);
        }
      }

      let uniqueParts = unique(parts);

      if (uniqueParts.length == 2) {
        if (DEBUG) {
          foundGears[y] ||= [];
          foundGears[y].push(x);
        }

        let partNumbers = uniqueParts.map((p) => {
          let [py, px] = p;
          let partNumber = getNumberAt(+px, lines[py]);
          if (DEBUG) {
            foundNumbers[py] ||= [];
            foundNumbers[py] = foundNumbers[py].concat(px);
          }
          return partNumber;
        });

        let ratio = partNumbers.reduce((p: number, c: number) => p * c, 1);
        ratios.push(ratio);
      }
    }
  }

  let debugLines = lines.map((line, y) => {
    return line.replace(/\*|\d+/g, (m, x) => {
      if (m === "*" && foundGears[y]?.includes(x)) {
        return `<span style='background:black'>*</span>`;
      }
      if (foundNumbers[y]?.includes(x)) {
        return `<span style='background:orange'>${m}</span>`;
      }
      return m;
    });
  });

  DEBUG && writeFileSync("debug-2.html", `<html><pre style='color:#999'>${debugLines.join("\n")}</pre></html>`);

  return ratios.reduce((p, c) => p + c, 0);
}

console.log(part2());
