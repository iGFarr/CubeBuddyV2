//
//  ScrambledCubeGraphicVC.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/26/22.
//

import UIKit

class ScrambledCubeGraphicVC: CBBaseViewController {
    var scramble = ""
    var cube = Cube()
    var rootVC: TimerViewController?
    var timer: Timer?
    var timeElapsed = 0.00
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeElapsed = rootVC?.viewModel?.timeElapsed ?? 0.00
        let formattedTimerString = CBBrain.formatTimeForTimerLabel(timeElapsed: self.timeElapsed)
        if self.rootVC?.viewModel?.timerRunning ?? true {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                self.timerUpdatesUI()
            }
            self.title = formattedTimerString
        } else {
            self.title = self.rootVC?.viewModel?.runningTimerLabel.text
        }
        updateCubeGraphic(with: cube)
    }
    
    func updateCubeGraphic(with cube: Cube){
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        CBViewCreator.createCubeGraphicView(for: self, with: cube)
    }
    
    func timerUpdatesUI(){
        self.timeElapsed += 0.01
        let formattedTimerString = CBBrain.formatTimeForTimerLabel(timeElapsed: self.timeElapsed)
        self.title = formattedTimerString
    }
}
