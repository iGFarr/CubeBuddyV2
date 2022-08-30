//
//  CBTableViewCellCreator.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/30/22.
//

import Foundation
import UIKit

struct CBTableViewCellCreator {
    static func createAlertCellWith(actions: [UIAlertAction], alertTitle: String = "WARNING", alertMessage: String = "You are about to delete all your solves permanently.", for tableView: UITableView, in viewController: CBBaseTableViewController) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = "Clear All"
        cell.textLabel?.textColor = .systemRed
        cell.textLabel?.font = UIFont.CBFonts.primary
        cell.backgroundColor = .clear
        createCellSeparator(for: cell)
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
    
    static func createCellSeparator(for cell: UITableViewCell) {
        let view = CBView()
        cell.addSubview(view)
        view.heightAnchor.constraint(equalToConstant: CBConstants.UIConstants.cellSeparatorHeight).isActive = true
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - CBConstants.UIConstants.doubleInset).isActive = true
        view.centerYAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        view.backgroundColor = .CBTheme.secondary
    }
}
