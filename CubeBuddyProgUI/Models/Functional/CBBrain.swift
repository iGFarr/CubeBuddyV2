//
//  CBBrain.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/7/22.
//

import Foundation
import UIKit

// CBBrain is for global utility functions
struct CBBrain {
    static func getScramble(length numMoves: Int = CBConstants.defaultScrambleLength) -> String {
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
        scrambleString = "Scramble".localized() + ":\n" + scrambleString
        return scrambleString
    }
    
    static func getAttributedScrambleTextOfLength(_ length: Int) -> NSAttributedString {
        return CBConstants.UI.makeTextAttributedWithCBStyle(text: getScramble(length: length))
    }
    
    // Formats times as Time (conditionally shown** NN:) + NN:NN. Adding number pairs to the left as necessary. e.g. at 61.5 seconds, outputs Time 01:01:50. At 5 seconds, shows 05:00
    static func formatTimeForTimerLabel(timeElapsed: Double, droppingPrefix: Bool = false) -> String {
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
        
        let formattedTimerString = "Time".localized() + ": \(useHours ? (hourString + ":"): "")\(useMinutes ? (minuteString + ":") : "")\(secondString):\(milliString)"
        return droppingPrefix ? String(formattedTimerString.dropFirst("Time: ".count)) : formattedTimerString
    }
    
    static func formatDate(_ date: Date = Date()) -> String {
        let now = date
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.setLocalizedDateFormatFromTemplate("MM-dd-YYYY HH:mm")
        let dateString = formatter.string(from: now)
        return dateString
    }
    
    static func retrieveRecentAverageOf(_ number: Int = 5) -> Double? {
        guard let solves = AppDelegate.loadCoreData(retrievableObject: Solve()) as? [Solve], solves.count >= number, number >= 3 else {
            return nil
        }
        var lastXSolves = solves[(solves.count - number)...(solves.count - 1)]
        lastXSolves.sort { $0 > $1 }
        var average = 0.0
        var total = 0.0
        if !lastXSolves.isEmpty {
            lastXSolves.removeLast()
            lastXSolves.removeFirst()
        }
        for solve in lastXSolves {
            total += solve.timeAsDouble
        }
        average = total / Double(lastXSolves.count)
        return average
    }
    
    static func retrieveFromSolveSetAvgOf(_ number: Int = 5, solves: [Solve]) -> Double? {
        guard solves.count >= number, number >= 3 else {
            return nil
        }
        var lastXSolves = solves[(solves.count - number)...(solves.count - 1)]
        lastXSolves.sort { $0 > $1 }
        var average = 0.0
        var total = 0.0
        if !lastXSolves.isEmpty {
            lastXSolves.removeLast()
            lastXSolves.removeFirst()
        }
        for solve in lastXSolves {
            total += solve.timeAsDouble
        }
        average = total / Double(number - 2)
        return average
    }
    
    static func getAccessibilityLabelFor(scramble: String) -> String {
        var accessibilityText = scramble.replacingOccurrences(of: " ", with: "\n \n")
        accessibilityText = accessibilityText.replacingOccurrences(of: "'", with: "Prime")
        return accessibilityText
    }
    
    static func makeMovesFromString(cube: Cube, text: String) -> Cube {
        let cubeCopy = cube.makeMoves(cube.convertStringToMoveList(scramble: text.dropFirst(("Scramble".localized() + ":\n").count).split(separator: " ").map { move in
            String(move)
        }))
        return cubeCopy
    }
}
