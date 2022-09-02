//
//  SolveModel.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/26/22.
//

import UIKit

// Internally populated model for solve cells in SolvesViewController
struct Solve: Codable {
    var scramble: String
    var time: String
    var puzzle: String
    
    init(scramble: String, time: String, puzzle: String = CBConstants.defaultPuzzleDescription) {
        self.scramble = scramble
        self.time = time
        self.puzzle = puzzle
    }
}
