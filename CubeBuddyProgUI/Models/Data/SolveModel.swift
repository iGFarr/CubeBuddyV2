//
//  SolveModel.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/26/22.
//

import UIKit

struct Solve: Codable {
    var scramble: String
    var time: String
    var puzzle: String
    
    init(scramble: String, time: String, puzzle: String = "3x3") {
        self.scramble = scramble
        self.time = time
        self.puzzle = puzzle
    }
    
    func createSolveCell(for table: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "solveCell", for: indexPath) as! SolveCellModel
        cell.solveTimeLabel.text = self.time
        cell.scrambleLabel.text = self.scramble
        cell.puzzleLabel.text = self.puzzle
        return cell
    }
}
