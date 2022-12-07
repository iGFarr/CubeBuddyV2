//
//  CBTableViewCellCreator.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/30/22.
//

import Foundation
import UIKit

struct CBTableViewCellCreator {
//    let deleteClosure: (UIAlertAction) -> Void = { action in
//        self.deleteSolves()
//        self.solves.removeAll()
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
    static func getCancelDeleteAlertWithClosure(_ deleteAction: @escaping (UIAlertAction) -> Void, alertTitle: String = "WARNING".localized(), alertMessage: String = "WARNING MESSAGE".localized(), in viewController: UIViewController) {
        var actions = [UIAlertAction]()
        actions.append(UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default, handler: nil))
        actions.append(UIAlertAction(title: "Delete".localized(), style: UIAlertAction.Style.destructive, handler: deleteAction))
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func createAlertCellWith(actions: [UIAlertAction]? = nil, alertTitle: String = "WARNING".localized(), alertMessage: String = "WARNING MESSAGE".localized(), for tableView: UITableView, in viewController: UIViewController, deleteAction: @escaping (UIAlertAction) -> Void) -> CBBaseTableViewCell {
        let cell = CBBaseTableViewCell()
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = "Clear All".localized()
        cell.textLabel?.textColor = .systemRed
        createCellSeparator(for: cell, at: .topAndBottom)
        cell.addTapGestureRecognizer {
            getCancelDeleteAlertWithClosure(deleteAction, alertTitle: alertTitle, alertMessage: alertMessage, in: viewController)
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
