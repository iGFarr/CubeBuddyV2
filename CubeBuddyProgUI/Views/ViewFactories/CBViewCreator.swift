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
        var delegate: CubeDelegate?
        var timerRunning = false
        let scrambleLengthLabel = CBLabel()
        let scrambleLabel = CBLabel()
        let runningTimerLabel = CBLabel()
        let scrambleLengthSlider = CBSlider()
        let puzzleChoiceSegmentedControl = CBSegmentedControl(items: ["3x3", "4x4", "5x5", "6x6", "7x7"])
        var timeElapsed = 0.00
        var timer: Timer?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc
        func sliderValueChanged() {
            UserDefaults.standard.setValue(scrambleLengthSlider.value, forKey: UserDefaultsHelper.DefaultKeys.scrambleLength.rawValue)
            let sliderValueRoundedDown = Int(floor(scrambleLengthSlider.value))
            scrambleLengthLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "Scramble Length".localized() + ": " + String(sliderValueRoundedDown), size: .small)
            if timerRunning == false {
                let scrambleText = CBConstants.UI.makeTextAttributedWithCBStyle(text: CBBrain.getScramble(length: sliderValueRoundedDown), size: .large)
                scrambleLabel.attributedText = scrambleText
                if sliderValueRoundedDown < 1 {
                    scrambleLabel.isHidden = true
                } else {
                    scrambleLabel.isHidden = false
                }
            }
            var cube = Cube()
            if let text = scrambleLabel.text {
                cube = cube.makeMoves(cube.convertStringToMoveList(scramble: text.dropFirst(("Scramble".localized() + ":\n").count).split(separator: " ").map { move in
                    String(move)
                }))
                timerRunning = false
                self.delegate?.updateCube(cube: cube)
            }
        }
        
        func createTimerView(for viewController: TimerViewController, usingOptionsBar: Bool = false) {            
            func timerUpdatesUI(){
                self.timeElapsed += 0.01
                let formattedTimerString = CBBrain.formatTimeForTimerLabel(timeElapsed: self.timeElapsed)
                self.runningTimerLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: formattedTimerString, size: .xl)
            }
            
            let unselectedColor: UIColor = .CBTheme.secondary ?? .systemGreen
            let selectedColor: UIColor = .CBTheme.primary ?? .systemBlue
            puzzleChoiceSegmentedControl.selectedSegmentIndex = 0
            puzzleChoiceSegmentedControl.selectedSegmentTintColor = .CBTheme.secondary
            puzzleChoiceSegmentedControl.setTitleTextAttributes([
                .font: UIFont.CBFonts.returnCustomFont(size: .small),
                .foregroundColor: unselectedColor
            ], for: .normal)
            puzzleChoiceSegmentedControl.setTitleTextAttributes([
                .font: UIFont.CBFonts.returnCustomFont(size: .small),
                .foregroundColor: selectedColor
            ], for: .selected)
            
            scrambleLengthSlider.thumbTintColor = .CBTheme.secondary
            scrambleLengthSlider.maximumValue = 40
            scrambleLengthSlider.minimumValue = 0
            let scrambleLength = UserDefaults.standard.float(forKey: UserDefaultsHelper.DefaultKeys.scrambleLength.rawValue)
            scrambleLengthSlider.setValue(scrambleLength, animated: false)
            scrambleLengthSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
            if scrambleLengthSlider.value == 0 {
                scrambleLabel.isHidden = true
            }
            
            let sliderValueRoundedDown = Int(floor(scrambleLengthSlider.value))
            scrambleLengthLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "Scramble Length".localized() + ": " + String(sliderValueRoundedDown), size: .small)
            let scrambleText = CBConstants.UI.makeTextAttributedWithCBStyle(text: CBBrain.getScramble(length: sliderValueRoundedDown), size: .large)
            scrambleLabel.attributedText = scrambleText
            
            func timerButtonViewPressed(){
                let sliderValueRoundedDown = floor(scrambleLengthSlider.value)
                timer?.invalidate()
                if self.timerRunning == false && self.timeElapsed == 0.00 {
                    timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                        timerUpdatesUI()
                    }
                    timer?.fire()
                    self.timerRunning = true
                    if sliderValueRoundedDown != 0 {
                        scrambleLabel.isHidden = false
                    } else if sliderValueRoundedDown == 0 {
                        scrambleLabel.isHidden = true
                    }
                } else {
                    let newSolve = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Solve", in: viewController.context) ?? NSEntityDescription(), insertInto: viewController.context)
                    newSolve.setValue(floor(scrambleLengthSlider.value) != 0 ? (scrambleLabel.text ?? "No scramble") : "No Scramble", forKey: "scramble")
                    newSolve.setValue(runningTimerLabel.text ?? "No timer", forKey: "time")
                    newSolve.setValue("\(self.puzzleChoiceSegmentedControl.selectedSegmentIndex + Int(CBConstants.defaultPuzzleSize))x\(self.puzzleChoiceSegmentedControl.selectedSegmentIndex + Int(CBConstants.defaultPuzzleSize))", forKey: "puzzle")
                    newSolve.setValue(CBBrain.formatDate(), forKey: "date")
                    viewController.saveCoreData()
                    let scrambleText = CBConstants.UI.makeTextAttributedWithCBStyle(text: CBBrain.getScramble(length: Int(sliderValueRoundedDown)), size: .large)
                    scrambleLabel.attributedText = scrambleText
                    self.timerRunning = false
                    self.timeElapsed = 0.00
                    viewController.cube = Cube()
                    if sliderValueRoundedDown != 0 && scrambleLabel.isHidden {
                        scrambleLabel.isHidden = false
                    } else if sliderValueRoundedDown == 0 {
                        scrambleLabel.isHidden = true
                    }
                }
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
            self.runningTimerLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "Time".localized() + ": 00:00", size: .xl)
            
            CBConstraintHelper.constrain(containerView, toSafeAreaOf: view, usingInsets: false)
            containerView.addSubviews([
                optionsBar,
                timerButtonView,
                scrambleLabel,
                scrambleLengthSlider,
                scrambleLengthLabel,
                puzzleChoiceSegmentedControl
            ])
            
            timerButtonView.addSubview(runningTimerLabel)
            
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
                    puzzleChoiceSegmentedControl.bottomAnchor.constraint(equalTo: scrambleLengthLabel.topAnchor, constant: -CBConstants.UI.defaultInsets)
                ])
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
            if let text = vc.viewModel?.scrambleLabel.text, vc.cube == Cube() {
                cube = cube.makeMoves(cube.convertStringToMoveList(scramble: text.dropFirst(("Scramble".localized() + ":\n").count).split(separator: " ").map { move in
                    String(move)
                }))
            } else {
                cube = vc.cube
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
        var stackViewDimension = CBConstants.defaultPuzzleSize * CBConstants.UI.cubeTileDimension + CBConstants.UI.defaultStackViewSpacing
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
                
                switch stack {
                case 1:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: face.a)
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: face.b)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: face.c)
                    }
                case 2:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: face.d)
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: face.e)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: face.f)
                    }
                case 3:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: face.g)
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: face.h)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: face.i)
                    }
                default:
                    break
                }
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
