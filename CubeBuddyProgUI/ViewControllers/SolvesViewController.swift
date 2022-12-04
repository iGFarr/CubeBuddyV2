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
        solves = loadCoreData(retrievableObject: Solve())
        title = CBConstants.CBMenuPickerPages.solves.rawValue.localized()
        tableView.register(SolveCellModel.self, forCellReuseIdentifier: "solveCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        solves = loadCoreData(retrievableObject: Solve())
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
            context.delete(solve)
            solves.remove(at: currentSolveIndex)
            tableView.deleteRows(at: [indexPath], with: .fade)
            do
            {
                try context.save()
            }
            catch
            {
                print ("There was an error")
            }
            tableView.reloadData()
        }
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
    }
}
