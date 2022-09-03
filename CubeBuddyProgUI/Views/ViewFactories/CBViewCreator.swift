//
//  CBViewCreator.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/4/22.
//

import UIKit

struct CBViewCreator {
    static func configureThemeChangeButton(for vc: CBBaseViewController, size: CGFloat = 30) {
        let themeSwitchButton = CBButton()
        themeSwitchButton.heightConstant(size)
        themeSwitchButton.widthConstant(size)
        themeSwitchButton.setBackgroundImage(UIImage(systemName: "lightbulb"), for: .normal)
        themeSwitchButton.tintColor = .CBTheme.secondary ?? .systemGreen
        themeSwitchButton.addTapGestureRecognizer {
            self.themeChanged(vc: vc)
        }
        themeSwitchButton.constrainToCorner(.topLeft, in: vc.view, safeArea: true)
    }

    static func themeChanged(vc: CBBaseViewController) {
        switch vc.view.window?.traitCollection.userInterfaceStyle {
        case .light:
            vc.view.window?.overrideUserInterfaceStyle = .dark
        case .dark:
            vc.view.window?.overrideUserInterfaceStyle = .light
        default:
            vc.view.window?.overrideUserInterfaceStyle = .dark
        }
    }
    
    final class TimerView: UIView {
        var solves =  [Solve]()
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
            self.solves = UserDefaultsHelper.getAllObjects(named: .solves)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc
        func sliderValueChanged() {
            UserDefaults.standard.setValue(scrambleLengthSlider.value, forKey: UserDefaultsHelper.DefaultKeys.scrambleLength.rawValue)
            let scrambleText = CBConstants.UI.makeTextAttributedWithCBStyle(text: CBBrain.getScramble(length: Int(scrambleLengthSlider.value)), size: .large)
            scrambleLabel.attributedText = scrambleText
            scrambleLengthLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "Scramble Length: " + String(Int(scrambleLengthSlider.value)), size: .small)
        }
        
        func createTimerView(for viewController: TimerViewController, usingOptionsBar: Bool = false) {
            
            func timerUpdatesUI(){
                self.timeElapsed += 0.01
                let formattedTimerString = CBBrain.formatTimeForTimerLabel(timeElapsed: self.timeElapsed)
                self.runningTimerLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: formattedTimerString, size: .xl)
            }
            
            puzzleChoiceSegmentedControl.selectedSegmentIndex = 0
            puzzleChoiceSegmentedControl.selectedSegmentTintColor = .CBTheme.secondary
            let unselectedColor: UIColor = .CBTheme.secondary ?? .systemGreen
            let selectedColor: UIColor = .CBTheme.primary ?? .systemBlue
            puzzleChoiceSegmentedControl.setTitleTextAttributes([
                .font: UIFont.CBFonts.returnCustomFont(size: CBConstants.UI.isIpad ? .medium : .small),
                .foregroundColor: unselectedColor
            ], for: .normal)
            puzzleChoiceSegmentedControl.setTitleTextAttributes([
                .font: UIFont.CBFonts.returnCustomFont(size: CBConstants.UI.isIpad ? .medium : .small),
                .foregroundColor: selectedColor
            ], for: .selected)
            scrambleLengthSlider.thumbTintColor = .CBTheme.secondary
            scrambleLengthSlider.maximumValue = 40
            scrambleLengthSlider.minimumValue = 2
            var scrambleLength = UserDefaults.standard.float(forKey: UserDefaultsHelper.DefaultKeys.scrambleLength.rawValue)
            if scrambleLength == 0.0 {
                UserDefaults.standard.setValue(CBConstants.defaultScrambleSliderValue, forKey: UserDefaultsHelper.DefaultKeys.scrambleLength.rawValue)
                scrambleLength = CBConstants.defaultScrambleSliderValue
            }
            scrambleLengthSlider.setValue(scrambleLength, animated: false)
            scrambleLengthSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
            
            scrambleLengthLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "Scramble Length: " + String(Int(scrambleLengthSlider.value)), size: .small)
            
            let scrambleText = CBConstants.UI.makeTextAttributedWithCBStyle(text: CBBrain.getScramble(length: Int(scrambleLengthSlider.value)), size: .large)
            scrambleLabel.attributedText = scrambleText
            
            
            func timerButtonViewPressed(){
                timer?.invalidate()
                if self.timerRunning == false && self.timeElapsed == 0.00 {
                    timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                        timerUpdatesUI()
                    }
                    timer?.fire()
                    self.timerRunning = true
                } else {
                    let newSolve = Solve(scramble: scrambleLabel.text ?? "No scramble", time: runningTimerLabel.text ?? "No timer", puzzle: "\(self.puzzleChoiceSegmentedControl.selectedSegmentIndex + 3)x\(self.puzzleChoiceSegmentedControl.selectedSegmentIndex + 3)")
                    self.solves.append(newSolve)
                    UserDefaultsHelper.saveAllObjects(allObjects: solves, named: .solves)
                    print(solves.count)
                    let scrambleText = CBConstants.UI.makeTextAttributedWithCBStyle(text: CBBrain.getScramble(length: Int(scrambleLengthSlider.value)), size: .large)
                    scrambleLabel.attributedText = scrambleText
                    self.timerRunning = false
                    self.timeElapsed = 0.00
                    viewController.cube = Cube()
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
            self.runningTimerLabel.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "Time: 00:00", size: .xl)
            
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
                    timerButtonView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
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
        let buttonText = CBConstants.UI.makeTextAttributedWithCBStyle(text: "Show me the cube!", size: .large)
        
        showButton.layer.cornerRadius = CBConstants.UI.buttonCornerRadius
        showButton.layer.borderColor = UIColor.CBTheme.secondary?.cgColor
        showButton.layer.borderWidth = 2
        showButton.setAttributedTitle(buttonText, for: .normal)
        if #available(iOS 15.0, *) {
            showButton.configuration = .borderedTinted()
        }
        showButton.addTapGestureRecognizer {
            let cubeGraphicVC = ScrambledCubeGraphicVC()
            var cube = vc.cube
            if let text = vc.viewModel?.scrambleLabel.text, vc.cube == Cube() {
                cube = cube.makeMoves(cube.convertStringToMoveList(scramble: text.dropFirst("Scramble:\n".count).split(separator: " ").map { move in
                    String(move)
                }))
            } else {
                cube = vc.cube
            }
            vc.cube = cube
            
            cubeGraphicVC.scramble = vc.viewModel?.scrambleLabel.text ?? ""
            cubeGraphicVC.cube = cube
            cubeGraphicVC.rootVC = vc
            cubeGraphicVC.selectedPuzzleSize = CGFloat((vc.viewModel?.puzzleChoiceSegmentedControl.selectedSegmentIndex ?? 0) + 3)
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
        
        func configureTappableViewsForStack(stack: UIStackView, faceToTurn: CubeFace) {
            let leftTapView = CBView()
            let rightTapView = CBView()
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
                viewController.updateCubeGraphic(with: cubeCopy)
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
                viewController.updateCubeGraphic(with: cubeCopy)
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
        view.addSubview(containerView)
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
        downFaceVStack.bottom(backFaceVStack.topAnchor, constant: -CBConstants.UI.defaultInsetX4)
    }
    
    enum PossibleSide {
        case left
        case right
    }
    
    static func createLetterForCenterTile(in stackView: UIStackView, letter: String, on side: PossibleSide, color: UIColor = .black) {
        let letterView = CBLabel()
        letterView.attributedText = CBConstants.UI.makeTextAttributedWithCBStyle(text: letter, size: .small, color: color)
        stackView.addSubview(letterView)
        letterView.yAlignedWith(stackView)
        
        switch side {
        case .right:
            letterView.trailing(stackView.trailingAnchor, constant: -CBConstants.UI.defaultInsets)
        case .left:
            letterView.leading(stackView.leadingAnchor, constant: CBConstants.UI.defaultInsets)
        }
    }
    
    enum CubeFace: String {
        case up = "U"
        case down = "D"
        case back = "B"
        case front = "F"
        case left = "L"
        case right = "R"
    }
    
    static func configureStackViewForFace(face: Surface, letter: CubeFace, hasBorder: Bool = true, cubeSize: CGFloat = CBConstants.defaultPuzzleSize, in container: CBView) -> CBStackView {
        let stackView = CBStackView()
        
        // All constraints and dimensions are based around 3x3, and then scaled down to fit for larger cubes. So the overall face dimension is equal to 3 * tile size + some spacing
        var stackViewDimension = CBConstants.defaultPuzzleSize * CBConstants.UI.cubeTileDimension + CBConstants.UI.defaultStackViewSpacing
        if CBConstants.UI.isIpad {
            stackViewDimension *= CBConstants.UI.iPadScaleMultiplier
        }
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.heightConstant(stackViewDimension)
        stackView.widthConstant(stackViewDimension)
        container.addSubview(stackView)
        
        var tileDimension = CBConstants.UI.cubeTileDimension
        if CBConstants.UI.isIpad {
            tileDimension *= CBConstants.UI.iPadScaleMultiplier
        }
        for stack in 1...Int(cubeSize) {
            let hStack = CBStackView()
            stackView.addArrangedSubview(hStack)
            hStack.axis = .horizontal
            hStack.distribution = .equalSpacing
            
            for square in 1...Int(cubeSize) {
                let tileSquare = CBView()
                tileSquare.backgroundColor = .black
                tileSquare.widthConstant(tileDimension * (CBConstants.defaultPuzzleSize / cubeSize))
                tileSquare.layer.borderColor = UIColor.CBTheme.secondary?.cgColor
                tileSquare.layer.borderWidth = 2
                tileSquare.layer.cornerRadius = 6 * (CBConstants.defaultPuzzleSize / (1.5 * cubeSize))
                
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
            hStack.heightConstant(tileDimension * (CBConstants.defaultPuzzleSize / cubeSize))
        }
        if hasBorder {
            stackView.layer.borderColor = UIColor.CBTheme.secondary?.cgColor
            stackView.layer.borderWidth = 3
        }
        if cubeSize == CBConstants.defaultPuzzleSize {
            createLetterForCenterTile(in: stackView, letter: letter.rawValue, on: .right)
            createLetterForCenterTile(in: stackView, letter: letter.rawValue + "'", on: .left)
        }
        return stackView
    }
}
