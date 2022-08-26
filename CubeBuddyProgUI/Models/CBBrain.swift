//
//  CBBrain.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/7/22.
//

import UIKit

class CBBrain {
    class func getScramble() -> String {
        let cubeMoves = ["U", "D", "R", "L", "F", "B"]
        let primeMoves = cubeMoves.map { $0 + "'" }
        var numMoves = 20
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
}
