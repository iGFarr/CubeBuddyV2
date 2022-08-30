//
//  CBTableViewCellCreator.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/30/22.
//

import Foundation
import UIKit

struct CBTableViewCellCreator {
    static func createDeleteAlertCellWith(actions: [UIAlertAction], for tableView: UITableView, in viewController: CBBaseTableViewController) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = "Clear All"
        cell.textLabel?.textColor = .systemRed
        cell.textLabel?.font = UIFont.CBFonts.primary
        cell.backgroundColor = .clear
        CBViewCreator.createCellSeparator(for: cell)
        cell.addTapGestureRecognizer {
            let alert = UIAlertController(title: "WARNING", message: "You are about to delete all your solves permanently.", preferredStyle: .alert)
            
            // add actions
            for action in actions {
                alert.addAction(action)
            }
            // show the alert
            viewController.present(alert, animated: true, completion: nil)
        }
        return cell
    }
}
