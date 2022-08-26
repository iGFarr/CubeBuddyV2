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
        self.solves = UserDefaultsHelper.getAllObjects(named: .solves)
        self.title = "Solves"
        tableView.register(SolveCellModel.self, forCellReuseIdentifier: "solveCell")
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.solves = UserDefaultsHelper.getAllObjects(named: .solves)
        tableView.reloadData()
    }
}

extension SolvesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
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
            cell.addTapGestureRecognizer {
                let alert = UIAlertController(title: "WARNING", message: "You are about to delete all your solves permanently.", preferredStyle: .alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                    self.deleteSolves()
                    self.solves.removeAll()
                    self.tableView.reloadData()
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "solveCell", for: indexPath) as! SolveCellModel
        let solve = solves[indexPath.row - 1]
        cell.solveTimeLabel.text = solve.time
        cell.scrambleLabel.text = solve.scramble
        cell.puzzleLabel.text = solve.puzzle
        return cell
    }
    
    func deleteSolves(){
        let solves = [Solve]()
        UserDefaultsHelper.saveAllObjects(allObjects: solves, named: .solves)
        print(solves.count)
    }
}
