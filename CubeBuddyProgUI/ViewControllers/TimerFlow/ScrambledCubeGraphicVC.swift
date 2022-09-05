//
//  ScrambledCubeGraphicVC.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/26/22.
//

import UIKit

class ScrambledCubeGraphicVC: CBBaseViewController, CubeDelegate {
    var work: DispatchWorkItem?
    var scramble = ""
    var cube = Cube()
    var rootVC: TimerViewController?
    var timer: Timer?
    var timeElapsed = 0.00
    var selectedPuzzleSize: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        configureTimer()
        updateCubeGraphic(with: cube)
        work = DispatchWorkItem(block: {
            self.updateCubeGraphic(with: Cube())
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    func updateCube(cube: Cube) {
        self.cube = cube
        updateCubeGraphic(with: self.cube)
    }
    
    func cancelUpdate() {
        work?.cancel()
        work = DispatchWorkItem(block: {
            self.updateCubeGraphic(with: Cube())
        })
    }
    
    func updateCubeGraphic(with cube: Cube){
        for view in view.subviews {
            view.removeFromSuperview()
        }
        CBViewCreator.createCubeGraphicView(for: self, with: cube)
        configureWipLabel()
        CBButtonCreator.configureSoundSwitchButton(for: self)
        CBButtonCreator.configureExplosionsSwitchButton(for: self)
        CBButtonCreator.configureCubeResetButton(for: self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateCubeGraphic(with: cube)
    }

    func timerUpdatesUI(){
        timeElapsed += 0.01
        let formattedTimerString = CBBrain.formatTimeForTimerLabel(timeElapsed: timeElapsed)
        title = formattedTimerString
    }
    
    func configureTimer(){
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
    }
    //TEMP
    func configureWipLabel(){
        let wipLabel = CBLabel()
        wipLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "WIP", size: .xxl, color: .systemRed)
        wipLabel.textColor = .systemRed
        wipLabel.isHidden = false
        if self.selectedPuzzleSize == 3 {
            if self.cube == Cube() {
                wipLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "SOLVED".localized(), size: .xxl)
                self.timer?.invalidate()
                self.rootVC?.viewModel?.timer?.invalidate()
                self.rootVC?.viewModel?.timerRunning = false
                self.rootVC?.viewModel?.timeElapsed = 0.00
                let scrambleText = CBConstants.UI.makeTextAttributedWithCBStyle(text: CBBrain.getScramble(length: Int(self.rootVC?.viewModel?.scrambleLengthSlider.value ?? CBConstants.defaultScrambleSliderValue)), size: .large)
                self.rootVC?.viewModel?.scrambleLabel.attributedText = scrambleText
            } else {
                wipLabel.isHidden = true
            }
        }
        view.addSubview(wipLabel)
        wipLabel.xAlignedWith(view)
        wipLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return true
    }
}
