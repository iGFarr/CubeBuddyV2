//
//  SolvesViewController.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/3/22.
//

import UIKit
import CoreData

class SolvesViewController: CBBaseTableViewController {
    private var solves = [Solve]()
    private let clearAllCellIndex = 0
    private let clearAllCell = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        solves = loadCoreData()
        title = CBConstants.CBMenuPickerPages.solves.rawValue.localized()
        tableView.allowsMultipleSelection = true
        tableView.register(SolveCellModel.self, forCellReuseIdentifier: "solveCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        solves = loadCoreData()
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
        self.solves.count > 0 ? solves.count + clearAllCell : 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = CBBaseTableViewCell()
        
        if indexPath.row == clearAllCellIndex {
            var actions = [UIAlertAction]()
            actions.append(UIAlertAction(title: "Delete".localized(), style: UIAlertAction.Style.destructive, handler: { action in
                self.deleteSolves()
                self.solves.removeAll()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }))
            actions.append(UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default, handler: nil))
            
            cell = CBTableViewCellCreator.createAlertCellWith(actions: actions, for: tableView, in: self)
            return cell
        }
        
        guard solves.count > indexPath.row - clearAllCell else { return cell }
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
    
    private func deleteSolves(){
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Solve")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }
        saveCoreData()
    }
}
