//
//  CBBrain.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/7/22.
//

import Foundation

struct CBBrain {
    static func getScramble(length numMoves: Int = 20) -> String {
        let cubeMoves = ["U", "D", "R", "L", "F", "B"]
        let primeMoves = cubeMoves.map { $0 + "'" }
        var scrambleArray = [String]()
        for num in 0..<numMoves {
            var allMoves = cubeMoves + primeMoves
            var previousMove = ""
            var prime = false
            
            if num != 0 {
                previousMove = scrambleArray[num - 1]
            }
            
            if primeMoves.contains(previousMove) {
                prime = true
            }
            
            // prevents inverse moves from being adjacent to each other
            let oppositeMove = prime ? (previousMove.dropLast()) : (previousMove + "'")
            allMoves.removeAll { $0 == oppositeMove }
            
            // prevents the same move happening 3 consecutive times(non-sensical 270 degree turn)
            if num >= 2 {
                if previousMove == scrambleArray[num - 2] {
                    allMoves.removeAll() { $0 == previousMove }
                }
            }
            
            let randomMove = allMoves.randomElement() ?? ""
            scrambleArray.append(randomMove)
        }
        var scrambleString = scrambleArray.joined(separator: " ")
        scrambleString = "Scramble:\n" + scrambleString
        return scrambleString
    }
    
    static func formatTimeForTimerLabel(timeElapsed: Double) -> String {
        let hours = Int(timeElapsed) / 3600
        let hourString = String(hours)
        
        let minutes = Int(timeElapsed) / 60
        var minuteString = String(minutes)
        
        let seconds = Int(timeElapsed) % 60
        var secondString = String(seconds)
        
        let useHours = hours != 0
        let useMinutes = useHours || (minutes != 0)
        
        let milliseconds = Int(timeElapsed * 100)
        let msToHundredths = milliseconds % 100
        var milliString = String(msToHundredths)
        
        if minutes < 10 {
            minuteString = "0" + minuteString
        }
        if seconds < 10 {
            secondString = "0" + secondString
        }
        if msToHundredths < 10 {
            milliString = "0" + String(msToHundredths)
        }
        
        let formattedTimerString = "Time: \(useHours ? (hourString + ":"): "")\(useMinutes ? (minuteString + ":") : "")\(secondString):\(milliString)"
        return formattedTimerString
    }
}
