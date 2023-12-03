import { readFileSync, writeFileSync } from "fs";

let input = readFileSync("../inputs/day-3.txt", "utf-8")
let lines = input.trim().split(/\n/)
let parts = []
let debugLines = []

lines.forEach((line, lineIndex) => {
    let matches = line.matchAll(/\d+/g)
    let prev = lines[lineIndex - 1]
    let next = lines[lineIndex + 1]
    
    console.log('---')
    console.log(prev)
    console.log(line)
    console.log(next)
    let partsLine = []

    for (let match of matches) {
        let partNumber = match[0]
        let start = match.index
        let end = match.index + partNumber.length
        let prev = lines[lineIndex - 1]
        let next = lines[lineIndex + 1]
        // console.log(`\n${partNumber}`)
        if (findSymbol(line, start, end) || findSymbol(prev, start, end) || findSymbol(next, start, end)) {
            parts.push(+partNumber)
            partsLine.push(partNumber)
        } 
    }

    let debugLine = line;
    
        debugLine = debugLine.replaceAll(/[^.\d]/g, m => `<span style='background:red'>${m}</span>`).replaceAll(/\d+/g, m => {
            if (partsLine[0] === m) {
                partsLine.shift()
                return `<span style='background:yellow'>${m}</span>`
            } else {
                return `<span style='background:cyan'>${m}</span>`
            }
        })


    debugLines.push(debugLine)
})

function findSymbol(line: string | undefined, start: number, end: number) {
    if (!line) return false
    for (let i = Math.max(0, start - 1); i <= end && line[i]; i++) {
        if ( /[^.\d]/.test(line[i])) {
            return true
        }
    }
}

writeFileSync('debug.html', `<html><pre style="color: #999">${debugLines.join('\n')}</pre></html>`)