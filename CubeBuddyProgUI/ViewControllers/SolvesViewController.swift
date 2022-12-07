//
//  SolvesViewController.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/3/22.
//

import UIKit
import CoreData

class SolvesViewController: CBBaseTableViewController {
    private var solves = [RetrievableCDObject]()
    private let clearAllCellIndex = 0
    private let clearAllCell = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        solves = AppDelegate.loadCoreData(retrievableObject: Solve())
        title = CBConstants.CBMenuPickerPages.solves.rawValue.localized()
        tableView.register(SolveCellModel.self, forCellReuseIdentifier: "solveCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        solves = AppDelegate.loadCoreData(retrievableObject: Solve())
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
        return solves.count + clearAllCell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = CBBaseTableViewCell()
        let deleteClosure: (UIAlertAction) -> Void = { action in
            self.deleteSolves()
            self.solves.removeAll()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        if indexPath.row == clearAllCellIndex {
            cell = CBTableViewCellCreator.createAlertCellWith(for: tableView, in: self, deleteAction: deleteClosure)
            if solves.count == 0 {
                cell.isHidden = true
            } else {
                cell.isHidden = false
            }
            return cell
        }
        
        guard solves.count > indexPath.row - clearAllCell else { return cell }
        if let solve = solves[solves.count - indexPath.row] as? Solve {
            cell = CBTableViewCellCreator.createSolveCell(for: tableView, at: indexPath, with: solve)
        }
        cell.selectionStyle = .none
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentSolveIndex = solves.count - indexPath.row
            guard let solve = solves[currentSolveIndex] as? Solve  else {
                print("No solve to delete")
                return
            }
            solves.remove(at: currentSolveIndex)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            let deleteRequest = NSBatchDeleteRequest(objectIDs: [solve.objectID])
            do
            {
                try AppDelegate.context.execute(deleteRequest)
                AppDelegate.saveCoreData()
            }
            catch
            {
                print ("There was an error")
            }
        }
    }
    
    private func deleteSolves(){
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Solve")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try AppDelegate.context.execute(deleteRequest)
            AppDelegate.saveCoreData()
        }
        catch
        {
            print ("There was an error")
        }
    }
}
