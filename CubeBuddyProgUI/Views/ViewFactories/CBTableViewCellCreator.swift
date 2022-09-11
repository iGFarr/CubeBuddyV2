//
//  CBTableViewCellCreator.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/30/22.
//

import Foundation
import UIKit

struct CBTableViewCellCreator {
    static func createAlertCellWith(actions: [UIAlertAction], alertTitle: String = "WARNING".localized(), alertMessage: String = "WARNING MESSAGE".localized(), for tableView: UITableView, in viewController: CBBaseTableViewController) -> CBBaseTableViewCell {
        let cell = CBBaseTableViewCell()
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = "Clear All".localized()
        cell.textLabel?.textColor = .systemRed
        createCellSeparator(for: cell, at: .topAndBottom)
        cell.addTapGestureRecognizer {
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            for action in actions {
                alert.addAction(action)
            }
            viewController.present(alert, animated: true, completion: nil)
        }
        return cell
    }
    
    static func createSolveCell(for table: UITableView, at indexPath: IndexPath, with solve: Solve) -> CBBaseTableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "solveCell", for: indexPath) as! SolveCellModel
        cell.solveTimeLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: solve.time)
        cell.scrambleLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: solve.scramble)
        cell.puzzleLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: solve.puzzle, size: .small)
        cell.dateLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: solve.date, size: .small)
        return cell
    }
    
    static func createCellSeparator(for cell: UITableViewCell, at position: SeparatorPosition = .bottom) {
        let separator = CBView()
        cell.addSubview(separator)
        separator.backgroundColor = .CBTheme.secondary
        separator.heightConstant(CBConstants.UI.cellSeparatorHeight)
        separator.widthConstant(UIScreen.main.bounds.width - CBConstants.UI.doubleInset)
        switch position {
        case .top:
            separator.top(cell.topAnchor)
        case .bottom:
            separator.bottom(cell.bottomAnchor)
        case .topAndBottom:
            break
        }
        if position == .topAndBottom {
            separator.top(cell.topAnchor)
            let bottomSeparator = CBView()
            cell.addSubview(bottomSeparator)
            bottomSeparator.backgroundColor = .CBTheme.secondary
            bottomSeparator.heightConstant(CBConstants.UI.cellSeparatorHeight)
            bottomSeparator.widthConstant(UIScreen.main.bounds.width - CBConstants.UI.doubleInset)
            bottomSeparator.bottom(cell.bottomAnchor)
        }
    }
}
