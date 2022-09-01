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
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension SolvesViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.solves.count > 0 ? solves.count + 1 : 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.row == 0 {
            var actions = [UIAlertAction]()
            actions.append(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { action in
                self.deleteSolves()
                self.solves.removeAll()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }))
            actions.append(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            
            cell = CBTableViewCellCreator.createAlertCellWith(actions: actions, for: tableView, in: self)
            return cell
        }
        
        guard solves.count > indexPath.row - 1 else { return cell }
        let solve = solves[solves.count - indexPath.row]
        cell = CBTableViewCellCreator.createSolveCell(for: tableView, at: indexPath, with: solve)
        return cell
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
    }
}
