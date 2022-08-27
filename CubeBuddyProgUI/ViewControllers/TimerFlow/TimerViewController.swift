//
//  TimerViewController.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/2/22.
//

import UIKit

class TimerViewController: CBBaseViewController {
    var viewModel: CBViewCreator.TimerView?
    var cube = Cube()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CBViewCreator.TimerView()
        self.title = "Stopwatch"
        viewModel?.createTimerView(for: self, usingOptionsBar: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.solves = UserDefaultsHelper.getAllObjects(named: .solves)
    }
}
