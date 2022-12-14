//
//  CBViewCreator.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/4/22.
//

import UIKit
import CoreData

class CBViewCreator {
    final class TimerView: UIView {
        var solves =  [RetrievableCDObject]()
        var recentSolves = [RetrievableCDObject]()
        var delegate: CubeDelegate?
        var timerRunning = false
        let scrambleLengthLabel = CBLabel()
        let scrambleLabel = CBLabel()
        let runningTimerLabel = CBLabel()
        let ao5Label = CBLabel()
        let ao5CurrentLabel = CBLabel()
        let recentSessionTimesLabel = CBLabel()
        let aoxLabel = CBLabel()
        var xForCustomAvg: Int = Int(UserDefaultsHelper.getDoubleForKeyIfPresent(key: .customAvgX))
        let xStepper = CBStepper()
        let scrambleLengthSlider = CBSlider()
        let deleteLastSolveButton = CBButton()
        let deleteAllButton = CBButton()
        let selectedSession = 1
        let puzzleChoiceSegmentedControl = CBSegmentedControl(items: ["3x3", "4x4", "5x5", "6x6", "7x7"])
        var timeElapsed = 0.00
        var timer: Timer?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            updateAverages()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc
        func sliderValueChanged() {
            UserDefaultsHelper.setFloatFor(key: .scrambleLength, value: scrambleLengthSlider.value)
            let sliderValueRoundedDown = Int(floor(scrambleLengthSlider.value))
            scrambleLengthLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "Scramble Length".localized() + ": \(sliderValueRoundedDown)", size: .small)
            if !timerRunning {
                let scrambleText = CBBrain.getAttributedScrambleTextOfLength(sliderValueRoundedDown)
                scrambleLabel.attributedText = scrambleText
                scrambleLabel.accessibilityLabel = CBBrain.getAccessibilityLabelFor(scramble: scrambleText.string)
                if sliderValueRoundedDown == 0 {
                    scrambleLabel.isHidden = true
                } else {
                    scrambleLabel.isHidden = false
                }
            }
            setCubeForGraphic()
        }
        
        @objc
        func stepperValueChanged(){
            UserDefaultsHelper.setDoubleFor(key: .customAvgX, value: xStepper.value)
            xForCustomAvg = Int(xStepper.value)
            updateAverages()
        }
        
        func setCubeForGraphic(){
            var cube = Cube()
            if let text = scrambleLabel.text {
                cube = CBBrain.makeMovesFromString(cube: cube, text: text)
                timerRunning = false
                self.delegate?.updateCube(cube: cube)
            }
        }
        
        func createTimerView(for viewController: TimerViewController, usingOptionsBar: Bool = false) {
            func timerUpdatesUI(){
                self.timeElapsed += 0.01
                let formattedTimerString = CBBrain.formatTimeForTimerLabel(timeElapsed: self.timeElapsed)
                self.runningTimerLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: formattedTimerString, size: .large)
            }
            
            scrambleLengthSlider.maximumValue = 40
            scrambleLengthSlider.minimumValue = 0
            scrambleLengthSlider.setValue(UserDefaultsHelper.getFloatForKeyIfPresent(key: .scrambleLength), animated: false)
            xStepper.value = UserDefaultsHelper.getDoubleForKeyIfPresent(key: .customAvgX)
            xStepper.minimumValue = 3
            scrambleLengthSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
            xStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
            let sliderValueRoundedDown = Int(floor(scrambleLengthSlider.value))
            if sliderValueRoundedDown == 0 {
                scrambleLabel.isHidden = true
            }
            
            scrambleLengthLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "Scramble Length".localized() + ": \(sliderValueRoundedDown)", size: .small)
            let scrambleText = CBBrain.getAttributedScrambleTextOfLength(sliderValueRoundedDown)
            scrambleLabel.attributedText = scrambleText
            scrambleLabel.accessibilityLabel = CBBrain.getAccessibilityLabelFor(scramble: scrambleText.string)
            
            func timerButtonViewPressed(){
                let sliderValueRoundedDown = floor(scrambleLengthSlider.value)
                timer?.invalidate()
                if self.timerRunning == false && self.timeElapsed == 0.00 {
                    timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                        timerUpdatesUI()
                    }
                    timer?.fire()
                    self.timerRunning = true
                } else {
                    let newSolve = NSEntityDescription.insertNewObject(forEntityName: "Solve", into: AppDelegate.context)
                    newSolve.setValue(floor(scrambleLengthSlider.value) != 0 ? (scrambleLabel.text ?? "No scramble") : "No Scramble", forKey: "scramble")
                    newSolve.setValue(runningTimerLabel.text ?? "No timer", forKey: "time")
                    newSolve.setValue(self.timeElapsed, forKey: "timeAsDouble")
                    let selecedPuzzleSize = self.puzzleChoiceSegmentedControl.selectedSegmentIndex + Int(CBConstants.defaultPuzzleSize)
                    newSolve.setValue("\(selecedPuzzleSize)x\(selecedPuzzleSize)", forKey: "puzzle")
                    newSolve.setValue(CBBrain.formatDate(), forKey: "date")
                    
                    recentSolves.append(newSolve as! RetrievableCDObject)
                    // Having some Core Data context management issues. Will finish implementing saving separate solve sessions later
//                    let recentSolvesAsSet: NSOrderedSet = .init(array: recentSolves)
//                    updateSessionsWithRecentSolvesAsSet(recentSolvesAsSet)
                    AppDelegate.saveCoreData()
                    updateRecentSessionLabel()
                    updateAverages()
                    let scrambleText = CBBrain.getAttributedScrambleTextOfLength(Int(sliderValueRoundedDown))
                    scrambleLabel.attributedText = scrambleText
                    scrambleLabel.accessibilityLabel = CBBrain.getAccessibilityLabelFor(scramble: scrambleText.string)
                    self.timerRunning = false
                    self.timeElapsed = 0.00
                    viewController.cube = Cube()
                    if sliderValueRoundedDown != 0 && scrambleLabel.isHidden {
                        scrambleLabel.isHidden = false
                    } else if sliderValueRoundedDown == 0 {
                        scrambleLabel.isHidden = true
                    }
                }
                updateAccessibilityLabel()
            }
            
            guard let view = viewController.view else { return }
            
            let containerView = CBView()
            var optionsBar = CBView()
            let timerButtonView = CBView()
            
            if usingOptionsBar {
                optionsBar = createOptionsBar(for: viewController)
            }
            timerButtonView.addTapGestureRecognizer {
                timerButtonViewPressed()
            }
            timerButtonView.isAccessibilityElement = true
            updateAccessibilityLabel()
            self.runningTimerLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "Time".localized() + ": 00:00", size: .large)
            
            CBConstraintHelper.constrain(containerView, toSafeAreaOf: view, usingInsets: false)
            containerView.addSubviews([
                optionsBar,
                timerButtonView,
                scrambleLabel,
                runningTimerLabel,
                ao5CurrentLabel,
                ao5Label,
                aoxLabel,
                recentSessionTimesLabel,
                xStepper,
                deleteLastSolveButton,
                deleteAllButton,
                scrambleLengthSlider,
                scrambleLengthLabel,
                puzzleChoiceSegmentedControl
            ])
            let smallHeadlineLabels = [ao5Label, aoxLabel, ao5CurrentLabel, recentSessionTimesLabel]
            CBLabel.setFontForLabels(smallHeadlineLabels, font: UIFont.CBFonts.returnCustomFont(size: .small, textStyle: .headline))
            
            deleteLastSolveButton.layer.cornerRadius = CBConstants.UI.buttonCornerRadius
            var buttonText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "Delete Last", size: .small)
            deleteLastSolveButton.tintColor = .systemRed
            deleteLastSolveButton.layer.borderColor = UIColor.CBTheme.secondary?.resolvedColor(with: UITraitCollection.current).cgColor
            deleteLastSolveButton.layer.borderWidth = 2
            deleteLastSolveButton.clipsToBounds = true
            if #available(iOS 15.0, *) {
                deleteLastSolveButton.configuration = .filled()
            }
            deleteLastSolveButton.setAttributedTitle(buttonText, for: .normal)
            deleteLastSolveButton.addTapGestureRecognizer {
                self.deleteLastSolve(from: viewController)
            }
            
            deleteAllButton.layer.cornerRadius = CBConstants.UI.buttonCornerRadius
            buttonText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "Delete All", size: .small)
            deleteAllButton.tintColor = .systemRed
            deleteAllButton.layer.borderColor = UIColor.CBTheme.secondary?.resolvedColor(with: UITraitCollection.current).cgColor
            deleteAllButton.layer.borderWidth = 2
            deleteAllButton.clipsToBounds = true
            if #available(iOS 15.0, *) {
                deleteAllButton.configuration = .filled()
            }
            deleteAllButton.setAttributedTitle(buttonText, for: .normal)
            deleteAllButton.addTapGestureRecognizer {
                self.deleteAllSolves(from: viewController)
            }
            NSLayoutConstraint.activate(
                [
                    optionsBar.topAnchor.constraint(equalTo: containerView.topAnchor),
                    optionsBar.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                    optionsBar.heightAnchor.constraint(lessThanOrEqualToConstant: usingOptionsBar ? 100 : 0),
                    
                    scrambleLabel.topAnchor.constraint(equalTo: optionsBar.bottomAnchor, constant: CBConstants.UI.doubleInset),
                    scrambleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: CBConstants.UI.doubleInset),
                    scrambleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -CBConstants.UI.doubleInset),
                    
                    timerButtonView.topAnchor.constraint(equalTo: optionsBar.bottomAnchor, constant: CBConstants.UI.defaultInsetX4),
                    timerButtonView.bottomAnchor.constraint(equalTo: puzzleChoiceSegmentedControl.topAnchor),
                    timerButtonView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                    
                    runningTimerLabel.centerXAnchor.constraint(equalTo: timerButtonView.centerXAnchor),
                    runningTimerLabel.topAnchor.constraint(equalTo: scrambleLabel.bottomAnchor, constant: CBConstants.UI.defaultInsets),
                    
                    scrambleLengthLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                    scrambleLengthLabel.bottomAnchor.constraint(equalTo: scrambleLengthSlider.topAnchor, constant: -CBConstants.UI.defaultInsets),
                    
                    scrambleLengthSlider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: CBConstants.UI.doubleInset),
                    scrambleLengthSlider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -CBConstants.UI.doubleInset),
                    scrambleLengthSlider.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -CBConstants.UI.doubleInset),
                    scrambleLengthSlider.heightAnchor.constraint(equalToConstant: 30),
                    
                    puzzleChoiceSegmentedControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                    puzzleChoiceSegmentedControl.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -CBConstants.UI.doubleInset),
                    puzzleChoiceSegmentedControl.heightAnchor.constraint(equalToConstant: CBConstants.UI.isIpad ? 60 : 30),
                    puzzleChoiceSegmentedControl.bottomAnchor.constraint(equalTo: scrambleLengthLabel.topAnchor, constant: -CBConstants.UI.defaultInsets),
                    
                    deleteLastSolveButton.bottomAnchor.constraint(equalTo: deleteAllButton.topAnchor, constant: -CBConstants.UI.defaultInsets),
                    deleteLastSolveButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: CBConstants.UI.doubleInset),
                    
                    deleteAllButton.bottomAnchor.constraint(equalTo: puzzleChoiceSegmentedControl.topAnchor, constant: -CBConstants.UI.doubleInset),
                    deleteAllButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: CBConstants.UI.doubleInset),
                    
                    ao5CurrentLabel.bottomAnchor.constraint(equalTo: ao5Label.topAnchor, constant: -CBConstants.UI.defaultInsets),
                    ao5CurrentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: CBConstants.UI.doubleInset),
                    ao5CurrentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -CBConstants.UI.doubleInset),
                    
                    ao5Label.bottomAnchor.constraint(equalTo: aoxLabel.topAnchor, constant: -CBConstants.UI.defaultInsets),
                    ao5Label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: CBConstants.UI.doubleInset),
                    ao5Label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -CBConstants.UI.doubleInset),
                    
                    aoxLabel.bottomAnchor.constraint(equalTo: xStepper.topAnchor, constant: -CBConstants.UI.defaultInsets),
                    aoxLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: CBConstants.UI.doubleInset),
                    aoxLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -CBConstants.UI.doubleInset),
                    
                    xStepper.leadingAnchor.constraint(equalTo: aoxLabel.leadingAnchor),
                    xStepper.bottomAnchor.constraint(equalTo: deleteLastSolveButton.topAnchor, constant: -CBConstants.UI.defaultInsets),
                    
                    recentSessionTimesLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -CBConstants.UI.defaultInsets),
                    recentSessionTimesLabel.bottomAnchor.constraint(equalTo: deleteAllButton.bottomAnchor),
                    recentSessionTimesLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200)
                ])
            
            func updateAccessibilityLabel() {
                if timerRunning {
                    timerButtonView.accessibilityLabel = "Stop"
                } else {
                    timerButtonView.accessibilityLabel = "Start"
                }
            }
            
            func updateSessionsWithRecentSolvesAsSet(_ solveSet: NSOrderedSet) {
//                let sessionsRequest = SolveSession.createFetchRequest()
//                do {
//                    let results = try AppDelegate.context.fetch(sessionsRequest)
//                    print("\n\n")
//                    for result in results {
//                        if let result = result as? SolveSession, result.sessionId == selectedSession {
//                            print("Session Id: \(result.sessionId)")
//                            result.solves = solveSet
//                            let solves = result.solves
//                            print("Solve Count: \(solves.count)")
//                            for solve in solves {
//                                if let solve = solve as? Solve {
//                                    print(solve.timeAsDouble)
//                                }
//                            }
//                        }
//                    }
//                    if results.isEmpty {
//                        let newSolveSession = NSEntityDescription.insertNewObject(forEntityName: "SolveSession",
//                                                                                  into: AppDelegate.context)
//                        newSolveSession.setValue(solveSet, forKey: "solves")
//                        newSolveSession.setValue(selectedSession, forKey: "sessionId")
//                    }
//                    AppDelegate.saveCoreData()
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                }
            }
        }
        
        func deleteLastSolve(from vc: UIViewController) {
            guard let solve = AppDelegate.loadCoreData(retrievableObject: Solve()).last as? Solve  else {
                print("No solve to delete")
                return
            }
            let deleteAction: (UIAlertAction) -> Void = { action in
                if !self.solves.isEmpty {
                    self.solves.removeLast()
                }
                if !self.recentSolves.isEmpty {
                    self.recentSolves.removeLast()
                }
                let context = AppDelegate.context
                context.delete(solve)
                do
                {
                    try context.save()
                }
                catch
                {
                    print ("There was an error")
                }
                self.updateAverages()
                self.updateRecentSessionLabel()
            }
            CBTableViewCellCreator.getCancelDeleteAlertWithClosure(deleteAction, alertTitle: "Are you sure?", alertMessage: "Your last solve will be permanently deleted from memory, and from the current session.", in: vc)
 
        }
        
        func deleteAllSolves(from vc: UIViewController) {
            guard let _ = AppDelegate.loadCoreData(retrievableObject: Solve()).last as? Solve  else {
                print("No solve to delete")
                return
            }
            let deleteAction: (UIAlertAction) -> Void = { action in
                if !self.solves.isEmpty {
                    self.solves.removeAll()
                }
                if !self.recentSolves.isEmpty {
                    self.recentSolves.removeAll()
                }
                let context = AppDelegate.context
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
                self.updateAverages()
                self.updateRecentSessionLabel()
            }
            CBTableViewCellCreator.getCancelDeleteAlertWithClosure(deleteAction, alertTitle: "Are you sure?", alertMessage: "ALL of your solve data will be deleted, as well as the current session.", in: vc)
        }
        
        func updateAverages() {
            xForCustomAvg = Int(UserDefaultsHelper.getDoubleForKeyIfPresent(key: .customAvgX))
            if let average = CBBrain.retrieveRecentAverageOf(xForCustomAvg) {
                let formattedTime = CBBrain.formatTimeForTimerLabel(timeElapsed: average, droppingPrefix: true)
                aoxLabel.text = "Ao\(xForCustomAvg)(custom-all):\n\(formattedTime)"
            } else {
                aoxLabel.text = "Ao\(xForCustomAvg)(custom-all):\nN/A"
            }
            
            if let averageOf5 = CBBrain.retrieveRecentAverageOf() {
                let formattedTime = CBBrain.formatTimeForTimerLabel(timeElapsed: averageOf5, droppingPrefix: true)
                ao5Label.text = "Ao5(all):\n\(formattedTime)"
            } else {
                ao5Label.text = "Ao5(all):\nN/A"
            }
            
            if let solveSet = recentSolves as? [Solve], let averageOfCurrent = CBBrain.retrieveFromSolveSetAvgOf(solves: solveSet), recentSolves.count >= 5 {
                let formattedTime = CBBrain.formatTimeForTimerLabel(timeElapsed: averageOfCurrent, droppingPrefix: true)
                ao5CurrentLabel.text = "Ao5(current):\n\(formattedTime)"
            } else {
                ao5CurrentLabel.text = "Ao5(current):\nN/A"
            }
        }
        
        func updateRecentSessionLabel(){
            recentSessionTimesLabel.text = ""
            guard !recentSolves.isEmpty, var labelText = recentSessionTimesLabel.text else { return }
            let countToGoTo = recentSolves.count >= 5 ? 5 : recentSolves.count
            for solve in recentSolves.reversed()[0..<countToGoTo] {
                guard let solve = solve as? Solve else { return }
                labelText += "\n\(CBBrain.formatTimeForTimerLabel(timeElapsed: solve.timeAsDouble, droppingPrefix: true))"
            }
            recentSessionTimesLabel.text = labelText
        }

    }
        
        
    static func createOptionsBar(for vc: TimerViewController) -> CBView {
        let optionsBar = CBView()
        let showButton = CBButton()
        let buttonText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "Show Cube".localized(), size: .large)
        
        showButton.layer.cornerRadius = CBConstants.UI.buttonCornerRadius
        showButton.layer.borderColor = UIColor.CBTheme.secondary?.resolvedColor(with: UITraitCollection.current).cgColor
        
        showButton.layer.borderWidth = 2
        showButton.setAttributedTitle(buttonText, for: .normal)
        if #available(iOS 15.0, *) {
            showButton.configuration = .borderedTinted()
        }
        showButton.addTapGestureRecognizer {
            let cubeGraphicVC = ScrambledCubeGraphicVC()
            var cube = vc.cube
            if let text = vc.viewModel?.scrambleLabel.text {
                cube = CBBrain.makeMovesFromString(cube: cube, text: text)
            }
            vc.cube = cube
            
            cubeGraphicVC.scramble = vc.viewModel?.scrambleLabel.text ?? ""
            cubeGraphicVC.cube = cube
            cubeGraphicVC.rootVC = vc
            cubeGraphicVC.selectedPuzzleSize = CGFloat(vc.viewModel?.puzzleChoiceSegmentedControl.selectedSegmentIndex ?? 0) + CBConstants.defaultPuzzleSize
            vc.modalPresentationStyle = .fullScreen
            vc.navigationController?.pushViewController(cubeGraphicVC, animated: true)
        }
        
        optionsBar.isUserInteractionEnabled = true
        optionsBar.backgroundColor = .clear
        optionsBar.addSubview(showButton)
        
        NSLayoutConstraint.activate([
            showButton.centerXAnchor.constraint(equalTo: optionsBar.centerXAnchor),
            showButton.centerYAnchor.constraint(equalTo: optionsBar.centerYAnchor, constant: CBConstants.UI.defaultInsets),
            showButton.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - CBConstants.UI.defaultInsets)
        ])
        return optionsBar
    }
    
    static func createCubeGraphicView(for viewController: ScrambledCubeGraphicVC, with cube: Cube) {
        let presentingVC = viewController.presentingViewController as? TimerViewController
        var cubeCopy = presentingVC?.cube ?? cube
        let containerView = CBView()
        var transformAmount: CGFloat = 0
        
        func configureTappableViewsForStack(stack: UIStackView, faceToTurn: CubeFace) {
            let leftTapView = CBView()
            let rightTapView = CBView()
            let quarterTurn = CGFloat.pi / 2
            stack.addSubviews([
                leftTapView, rightTapView
            ])
            leftTapView.leading(stack.leadingAnchor)
            leftTapView.heightEqualsHeightOf(stack)
            leftTapView.widthConstant(CBConstants.UI.cubeButtonWidth)
            leftTapView.addTapGestureRecognizer {
                switch faceToTurn {
                case .up:
                    cubeCopy = cubeCopy.makeUp(.counterclockwise)
                case .down:
                    cubeCopy = cubeCopy.makeDown(.counterclockwise)
                case .left:
                    cubeCopy = cubeCopy.makeLeft(.counterclockwise)
                case .right:
                    cubeCopy = cubeCopy.makeRight(.counterclockwise)
                case .front:
                    cubeCopy = cubeCopy.makeFront(.counterclockwise)
                case .back:
                    cubeCopy = cubeCopy.makeBack(.counterclockwise)
                }
                viewController.cube = cubeCopy
                let timerVC = viewController.rootVC
                timerVC?.cube = cubeCopy
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut) {
                    stack.transform = CGAffineTransform(rotationAngle: -quarterTurn)
                } completion: { Bool in
                    if cubeCopy == Cube() {
                        viewController.configureWipLabel()
                        if viewController.soundsOn {
                            viewController.AVHelper.playVictorySound()
                        }
                        
                        if viewController.explosionsOn {
                            containerView.isUserInteractionEnabled = false
                            animationExplosion(view: containerView)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                viewController.updateCubeGraphic(with: cubeCopy)
                            }
                        } else {
                            viewController.updateCubeGraphic(with: cubeCopy)
                        }
                    } else {
                        viewController.updateCubeGraphic(with: cubeCopy)
                    }
                }
            }
            
            rightTapView.trailing(stack.trailingAnchor)
            rightTapView.heightEqualsHeightOf(stack)
            rightTapView.widthConstant(CBConstants.UI.cubeButtonWidth)
            rightTapView.addTapGestureRecognizer {
                switch faceToTurn {
                case .up:
                    cubeCopy = cubeCopy.makeUp(.clockwise)
                case .down:
                    cubeCopy = cubeCopy.makeDown(.clockwise)
                case .left:
                    cubeCopy = cubeCopy.makeLeft(.clockwise)
                case .right:
                    cubeCopy = cubeCopy.makeRight(.clockwise)
                case .front:
                    cubeCopy = cubeCopy.makeFront(.clockwise)
                case .back:
                    cubeCopy = cubeCopy.makeBack(.clockwise)
                }
                viewController.cube = cubeCopy
                let timerVC = viewController.rootVC
                timerVC?.cube = cubeCopy
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut) {
                    stack.transform = CGAffineTransform(rotationAngle: quarterTurn)
                } completion: { Bool in
                    if cubeCopy == Cube() {
                        viewController.configureWipLabel()
                        if viewController.soundsOn {
                            viewController.AVHelper.playVictorySound()
                        }
                        
                        if viewController.explosionsOn {
                            containerView.isUserInteractionEnabled = false
                            animationExplosion(view: containerView)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: viewController.work ?? DispatchWorkItem(block: {
                                print("No work item loaded")
                            }))
                        } else {
                            viewController.updateCubeGraphic(with: cubeCopy)
                        }
                    } else {
                        viewController.updateCubeGraphic(with: cubeCopy)
                    }
                }
            }
        }
        func animationExplosion(view: UIView){
            for subview in view.subviews {
                // Magnitude coefficients
                var xTransform: CGFloat = [1, -1, 2, -2].randomElement() ?? 1
                let yTransform: CGFloat = [1, -1, 2, -2].randomElement() ?? 1
                if subview.center.x < (view.center.x - CBConstants.UI.defaultInsets) {
                    xTransform = -1
                } else if subview.center.x > view.center.x {
                    xTransform = 1
                }
                let timer = Timer(timeInterval: 0.001, repeats: true) { _ in
                    transformAmount += 0.015
                    subview.transform = CGAffineTransform(rotationAngle: transformAmount/5).translatedBy(x: transformAmount * xTransform, y: transformAmount * yTransform)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    RunLoop.current.add(timer, forMode: .default)
                }
            }
        }
        // FACE STACKS
        let upFaceVStack = configureStackViewForFace(face: cubeCopy.up, letter: .up, cubeSize: viewController.selectedPuzzleSize, in: containerView)
        configureTappableViewsForStack(stack: upFaceVStack, faceToTurn: .up)
        let frontFaceVStack = configureStackViewForFace(face: cubeCopy.front, letter: .front, cubeSize: viewController.selectedPuzzleSize, in: containerView)
        configureTappableViewsForStack(stack: frontFaceVStack, faceToTurn: .front)
        let downFaceVStack = configureStackViewForFace(face: cubeCopy.down, letter: .down, cubeSize: viewController.selectedPuzzleSize, in: containerView)
        configureTappableViewsForStack(stack: downFaceVStack, faceToTurn: .down)
        let leftFaceVStack = configureStackViewForFace(face: cubeCopy.left, letter: .left, cubeSize: viewController.selectedPuzzleSize, in: containerView)
        configureTappableViewsForStack(stack: leftFaceVStack, faceToTurn: .left)
        let rightFaceVStack = configureStackViewForFace(face: cubeCopy.right, letter: .right, cubeSize: viewController.selectedPuzzleSize, in: containerView)
        configureTappableViewsForStack(stack: rightFaceVStack, faceToTurn: .right)
        let backFaceVStack = configureStackViewForFace(face: cubeCopy.back, letter: .back, cubeSize: viewController.selectedPuzzleSize, in: containerView)
        configureTappableViewsForStack(stack: backFaceVStack, faceToTurn: .back)
        
        guard let view = viewController.view else { return }
        CBConstraintHelper.constrain(containerView, toSafeAreaOf: view, usingInsets: true)
        
        upFaceVStack.xAlignedWith(containerView)
        upFaceVStack.bottom(frontFaceVStack.topAnchor, constant: -CBConstants.UI.defaultInsets)
        
        frontFaceVStack.xAlignedWith(containerView)
        frontFaceVStack.bottom(downFaceVStack.topAnchor, constant: -CBConstants.UI.defaultInsets)
        
        leftFaceVStack.trailing(frontFaceVStack.leadingAnchor, constant: -CBConstants.UI.defaultInsets)
        leftFaceVStack.yAlignedWith(frontFaceVStack)
        
        rightFaceVStack.leading(frontFaceVStack.trailingAnchor, constant: CBConstants.UI.defaultInsets)
        rightFaceVStack.yAlignedWith(frontFaceVStack)
        
        backFaceVStack.leading(containerView.leadingAnchor, constant: CBConstants.UI.doubleInset)
        backFaceVStack.bottom(containerView.bottomAnchor, constant: -CBConstants.UI.doubleInset)
        
        downFaceVStack.xAlignedWith(containerView)
        downFaceVStack.bottom(containerView.bottomAnchor, constant: -CBConstants.UI.defaultInsetX4)
    }
    
    static func createLetterForCenterTile(in stackView: UIStackView, letter: String, color: UIColor = .black) {
        let letterView = CBLabel()
        letterView.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: letter, size: .medium, strokeWidth: 6)
        stackView.superview?.addSubview(letterView)
        letterView.yAlignedWith(stackView)
        letterView.xAlignedWith(stackView)
    }
    
    static func configureStackViewForFace(face: Surface, letter: CubeFace, hasBorder: Bool = true, cubeSize: CGFloat = CBConstants.defaultPuzzleSize, in container: CBView) -> CBStackView {
        let stackView = CBStackView()
        
        // All constraints and dimensions are based around 3x3, and then scaled down to fit for larger cubes. So the overall face dimension is equal to 3 * tile size + some spacing
        let stackViewDimension = CBConstants.defaultPuzzleSize * CBConstants.UI.cubeTileDimension + CBConstants.UI.defaultStackViewSpacing
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.heightConstant(stackViewDimension)
        stackView.widthConstant(stackViewDimension)
        container.addSubview(stackView)
        
        for stack in 1...Int(cubeSize) {
            let hStack = CBStackView()
            stackView.addArrangedSubview(hStack)
            hStack.axis = .horizontal
            hStack.distribution = .equalSpacing
            
            for square in 1...Int(cubeSize) {
                let tileSquare = CBView()
                tileSquare.backgroundColor = .black
                tileSquare.widthConstant(CBConstants.UI.cubeTileDimension * (CBConstants.defaultPuzzleSize / cubeSize))
                tileSquare.layer.borderColor = UIColor.CBTheme.secondary?.cgColor
                tileSquare.layer.borderWidth = 2
                tileSquare.layer.cornerRadius = CBConstants.UI.defaultCornerRadius * (CBConstants.defaultPuzzleSize / (1.5 * cubeSize))
                let characterCode = Int(("a" as UnicodeScalar).value - 1) + ((stack - 1) * 3) + square
                let character = (Character(UnicodeScalar(characterCode) ?? UnicodeScalar(65)))
                tileSquare.backgroundColor = getColorForTile(tile: Cube.getTileForLetterFrom(face, letter: character))
                hStack.addArrangedSubview(tileSquare)
            }
            hStack.heightConstant(CBConstants.UI.cubeTileDimension * (CBConstants.defaultPuzzleSize / cubeSize))
        }
        if hasBorder {
            stackView.layer.borderColor = UIColor.CBTheme.secondary?.cgColor
            stackView.layer.borderWidth = 3
        }
        if cubeSize == CBConstants.defaultPuzzleSize {
            createLetterForCenterTile(in: stackView, letter: letter.rawValue)
        }
        return stackView
    }
}
