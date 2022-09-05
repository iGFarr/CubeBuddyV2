//
//  TimerViewController.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/2/22.
//
import UIKit

protocol CubeDelegate {
    var cube: Cube { get set }
    func updateCube (cube: Cube) -> Void
    func cancelUpdate () -> Void
}

extension CubeDelegate {
    func cancelUpdate(){
        print("Exectuing default implementation of cancelUpdate()")
    }
}

class TimerViewController: CBBaseViewController, CubeDelegate {
    func updateCube(cube: Cube) {
        self.cube = cube
    }
    
    var viewModel: CBViewCreator.TimerView?
    var cube = Cube()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
        title = CBConstants.CBMenuPickerPages.timer.rawValue.localized()
        viewModel = CBViewCreator.TimerView()
        viewModel?.createTimerView(for: self, usingOptionsBar: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.solves = UserDefaultsHelper.getAllObjects(named: .solves)
    }
}
