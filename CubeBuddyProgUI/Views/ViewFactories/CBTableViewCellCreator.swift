//
//  CBTableViewCellCreator.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/30/22.
//

import Foundation
import UIKit

enum SeparatorPosition {
    case top
    case bottom
    case topAndBottom
}
struct CBTableViewCellCreator {
    static func createAlertCellWith(actions: [UIAlertAction], alertTitle: String = "WARNING", alertMessage: String = "You are about to delete all your solves permanently.", for tableView: UITableView, in viewController: CBBaseTableViewController) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = "Clear All"
        cell.textLabel?.textColor = .systemRed
        cell.textLabel?.font = UIFont.CBFonts.primary
        cell.backgroundColor = .clear
        createCellSeparator(for: cell, at: .topAndBottom)
        cell.addTapGestureRecognizer {
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            
            // add actions
            for action in actions {
                alert.addAction(action)
            }
            // show the alert
            viewController.present(alert, animated: true, completion: nil)
        }
        return cell
    }
    
    static func createCellSeparator(for cell: UITableViewCell, at position: SeparatorPosition = .bottom) {
        let view = CBView()
        cell.addSubview(view)
        view.backgroundColor = .CBTheme.secondary
        view.heightAnchor.constraint(equalToConstant: CBConstants.UI.cellSeparatorHeight).isActive = true
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - CBConstants.UI.doubleInset).isActive = true
        switch position {
        case .top:
            view.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        case .bottom:
            view.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        case .topAndBottom:
            break
        }
        if position == .topAndBottom {
            view.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            let view = CBView()
            cell.addSubview(view)
            view.backgroundColor = .CBTheme.secondary
            view.heightAnchor.constraint(equalToConstant: CBConstants.UI.cellSeparatorHeight).isActive = true
            view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - CBConstants.UI.doubleInset).isActive = true
            view.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        }
    }
    
    static func createSolveCell(for table: UITableView, at indexPath: IndexPath, with solve: Solve) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "solveCell", for: indexPath) as! SolveCellModel
        cell.solveTimeLabel.text = solve.time
        cell.scrambleLabel.text = solve.scramble
        cell.puzzleLabel.text = solve.puzzle
        return cell
    }
}
