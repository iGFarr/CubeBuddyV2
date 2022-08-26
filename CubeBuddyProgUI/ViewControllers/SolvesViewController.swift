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
        self.solves = UserDefaultsHelper.getAllObjects(named: "solves")
        self.title = "Solves"
        tableView.register(SolveCellModel.self, forCellReuseIdentifier: "solveCell")
        tableView.tableFooterView = UIView()
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
        20
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "solveCell", for: indexPath) as! SolveCellModel
        cell.solveTimeLabel.text = "Time: " + String(format: "%.2f", 0.00 + Double(indexPath.row))
        var scrambleTest =  CBBrain.getScramble()
        cell.scrambleLabel.text = scrambleTest
        return cell
    }
}
