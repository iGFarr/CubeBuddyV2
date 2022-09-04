//
//  CBTableViewCellCreator.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/30/22.
//

import Foundation
import UIKit

struct CBTableViewCellCreator {
    static func createAlertCellWith(actions: [UIAlertAction], alertTitle: String = "WARNING", alertMessage: String = "You are about to delete all your solves permanently.", for tableView: UITableView, in viewController: CBBaseTableViewController) -> CBBaseTableViewCell {
        let cell = CBBaseTableViewCell()
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = "Clear All"
        cell.textLabel?.textColor = .systemRed
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
    
    static func createSolveCell(for table: UITableView, at indexPath: IndexPath, with solve: Solve) -> CBBaseTableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "solveCell", for: indexPath) as! SolveCellModel
        cell.solveTimeLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: solve.time)
        cell.scrambleLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: solve.scramble)
        cell.puzzleLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: solve.puzzle)
        return cell
    }
    
    static func createCellSeparator(for cell: UITableViewCell, at position: SeparatorPosition = .bottom) {
        let view = CBView()
        cell.addSubview(view)
        view.backgroundColor = .CBTheme.secondary
        view.heightConstant(CBConstants.UI.cellSeparatorHeight)
        view.widthConstant(UIScreen.main.bounds.width - CBConstants.UI.doubleInset)
        switch position {
        case .top:
            view.top(cell.topAnchor)
        case .bottom:
            view.bottom(cell.bottomAnchor)
        case .topAndBottom:
            break
        }
        if position == .topAndBottom {
            view.top(cell.topAnchor)
            let view = CBView()
            cell.addSubview(view)
            view.backgroundColor = .CBTheme.secondary
            view.heightConstant(CBConstants.UI.cellSeparatorHeight)
            view.widthConstant(UIScreen.main.bounds.width - CBConstants.UI.doubleInset)
            view.bottom(cell.bottomAnchor)
        }
    }
}
