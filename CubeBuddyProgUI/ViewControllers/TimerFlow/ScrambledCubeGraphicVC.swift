//
//  ScrambledCubeGraphicVC.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/26/22.
//

import UIKit
import SwiftUI

protocol GraphicPresenter {
    func show3DGraphic()
}

class ScrambledCubeGraphicVC: CBBaseViewController, CubeDelegate, GraphicPresenter {
    var work: DispatchWorkItem?
    var scramble = ""
    var cube = Cube() {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.changeCubeResetButtonColor()
            }
        }
    }
    var rootVC: TimerViewController?
    var timer: Timer?
    var timeElapsed = 0.00
    var selectedPuzzleSize = CBConstants.defaultPuzzleSize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTimer()
        updateCubeGraphic(with: cube)
        work = DispatchWorkItem(block: {
            self.updateCubeGraphic(with: Cube())
        })
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
        CBButtonCreator.configure3DGraphicButton(for: self)
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
        if self.selectedPuzzleSize == CBConstants.defaultPuzzleSize {
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
        wipLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90 * CBConstants.UI.scaleMultiplier).isActive = true
    }
    
    func changeCubeResetButtonColor(){
        self.cubeResetButton.removeFromSuperview()
        CBButtonCreator.configureCubeResetButton(for: self)
    }
    
    func show3DGraphic(){
        let vc = UIHostingController(rootView: ContentView())
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
