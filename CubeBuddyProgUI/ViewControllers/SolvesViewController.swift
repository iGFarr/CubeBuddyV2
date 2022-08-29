//
//  SolvesViewController.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/3/22.
//

import UIKit

class SolvesViewController: CBBaseTableViewController {
    private var solves = [Solve]()
    override func viewDidLoad() {
        super.viewDidLoad()
        solves = UserDefaultsHelper.getAllObjects(named: .solves)
        title = CBConstants.CBMenuPickerPages.solves.rawValue
        tableView.allowsMultipleSelection = true
        tableView.register(SolveCellModel.self, forCellReuseIdentifier: "solveCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        solves = UserDefaultsHelper.getAllObjects(named: .solves)
        tableView.reloadData()
    }
}

extension SolvesViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.solves.count + 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = "Clear All"
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.font = UIFont.CBFonts.primary
            cell.backgroundColor = .clear
            CBViewCreator.createCellSeparator(for: cell)
            cell.addTapGestureRecognizer {
                let alert = UIAlertController(title: "WARNING", message: "You are about to delete all your solves permanently.", preferredStyle: .alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { action in
                    self.deleteSolves()
                    self.solves.removeAll()
                    self.tableView.reloadData()
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            return cell
        } else {
            return solves[solves.count - indexPath.row].createSolveCell(for: tableView, at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow,
            indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at: indexPath, animated: false)
            return nil
        }
        return indexPath
    }
    
    func deleteSolves(){
        let solves = [Solve]()
        UserDefaultsHelper.saveAllObjects(allObjects: solves, named: .solves)
        print(solves.count)
    }
}
