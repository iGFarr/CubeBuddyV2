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
    var selectedPuzzleSize: CGFloat = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        timeElapsed = rootVC?.viewModel?.timeElapsed ?? 0.00
        let formattedTimerString = CBBrain.formatTimeForTimerLabel(timeElapsed: timeElapsed)
        if rootVC?.viewModel?.timerRunning ?? true {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                self.timerUpdatesUI()
            }
            title = formattedTimerString
        } else {
            title = rootVC?.viewModel?.runningTimerLabel.text
        }
        updateCubeGraphic(with: cube)
        configureWipLabel()
    }
    
    func updateCubeGraphic(with cube: Cube){
        for view in view.subviews {
            view.removeFromSuperview()
        }
        CBViewCreator.createCubeGraphicView(for: self, with: cube)
        configureWipLabel()
    }
    
    func timerUpdatesUI(){
        timeElapsed += 0.01
        let formattedTimerString = CBBrain.formatTimeForTimerLabel(timeElapsed: timeElapsed)
        title = formattedTimerString
    }
    
    //TEMP
    func configureWipLabel(){
        let wipLabel = CBLabel()
        wipLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "WIP", size: .xxl, color: .systemRed)
        wipLabel.textColor = .systemRed
        wipLabel.isHidden = false
        if self.selectedPuzzleSize == 3 {
            if self.cube == Cube() {
                wipLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "SOLVED", size: .xxl)
                self.timer?.invalidate()
                self.rootVC?.viewModel?.timer?.invalidate()
                self.rootVC?.viewModel?.timerRunning = false
                self.rootVC?.viewModel?.timeElapsed = 0.00
                let scrambleText = CBConstants.UI.makeTextAttributedWithCBStyle(text: CBBrain.getScramble(length: Int(self.rootVC?.viewModel?.scrambleLengthSlider.value ?? 20)), size: .large)
                self.rootVC?.viewModel?.scrambleLabel.attributedText = scrambleText
            } else {
                wipLabel.isHidden = true
            }
        }
        view.addSubview(wipLabel)
        wipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wipLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
    }
}
