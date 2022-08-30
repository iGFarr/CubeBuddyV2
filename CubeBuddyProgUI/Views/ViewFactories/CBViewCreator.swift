//
//  CBViewCreator.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/4/22.
//

import UIKit

class CBViewCreator {
    static func createCellSeparator(for cell: UITableViewCell) {
        let view = CBView()
        cell.addSubview(view)
        view.heightAnchor.constraint(equalToConstant: CBConstants.UIConstants.cellSeparatorHeight).isActive = true
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - CBConstants.UIConstants.doubleInset).isActive = true
        view.centerYAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        view.backgroundColor = .CBTheme.secondary
    }
    
    class TimerView: UIView {
        var solves =  [Solve]()
        var timerRunning = false
        let scrambleLengthLabel = CBLabel()
        let scrambleLabel = CBLabel()
        let runningTimerLabel = CBLabel()
        let scrambleLengthSlider = UISlider()
        var timeElapsed = 0.00
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.solves = UserDefaultsHelper.getAllObjects(named: .solves)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc func sliderValueChanged() {
            UserDefaults.standard.setValue(scrambleLengthSlider.value, forKey: UserDefaultsHelper.DefaultKeys.scrambleLength.rawValue)
            let scrambleText = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: CBBrain.getScramble(length: Int(scrambleLengthSlider.value)), size: .large)
            scrambleLabel.attributedText = scrambleText
            scrambleLengthLabel.attributedText = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: "Scramble Length: " + String(Int(scrambleLengthSlider.value)), size: .small)
        }
        
        func createTimerView(for viewController: TimerViewController, usingOptionsBar: Bool = false) {
            
            func timerUpdatesUI(){
                self.timeElapsed += 0.01
                let formattedTimerString = CBBrain.formatTimeForTimerLabel(timeElapsed: self.timeElapsed)
                self.runningTimerLabel.attributedText = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: formattedTimerString, size: .large)
            }
            
            scrambleLengthSlider.translatesAutoresizingMaskIntoConstraints = false
            scrambleLengthSlider.maximumValue = 40
            scrambleLengthSlider.minimumValue = 2
            var scrambleLength = UserDefaults.standard.float(forKey: UserDefaultsHelper.DefaultKeys.scrambleLength.rawValue)
            if scrambleLength == 0.0 {
                UserDefaults.standard.setValue(20.0, forKey: UserDefaultsHelper.DefaultKeys.scrambleLength.rawValue)
                scrambleLength = 20.0
            }
            scrambleLengthSlider.setValue(scrambleLength, animated: false)
            scrambleLengthSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
            
            scrambleLengthLabel.attributedText = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: "Scramble Length: " + String(Int(scrambleLengthSlider.value)), size: .small)
            
            let scrambleText = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: CBBrain.getScramble(length: Int(scrambleLengthSlider.value)), size: .large)
            scrambleLabel.attributedText = scrambleText
            var timer: Timer?
            
            func timerButtonViewPressed(){
                timer?.invalidate()
                if self.timerRunning == false {
                    timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                        timerUpdatesUI()
                    }
                    timer?.fire()
                    self.timerRunning = true
                } else {
                    let newSolve = Solve(scramble: scrambleLabel.text ?? "No scramble", time: runningTimerLabel.text ?? "No timer")
                    self.solves.append(newSolve)
                    UserDefaultsHelper.saveAllObjects(allObjects: solves, named: .solves)
                    print(solves.count)
                    let scrambleText = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: CBBrain.getScramble(length: Int(scrambleLengthSlider.value)), size: .large)
                    scrambleLabel.attributedText = scrambleText
                    self.timerRunning = false
                    self.timeElapsed = 0.00
                    viewController.cube = Cube()
                }
            }
            
            func createOptionsBar(for vc: TimerViewController) -> CBView {
                let optionsBar = CBView()
                let showButton = CBButton()
                let buttonText = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: "Show me the cube!", size: .large)
                
                showButton.layer.cornerRadius = CBConstants.UIConstants.buttonCornerRadius
                showButton.layer.borderColor = UIColor.CBTheme.secondary?.cgColor
                showButton.layer.borderWidth = 2
                showButton.setAttributedTitle(buttonText, for: .normal)
                if #available(iOS 15.0, *) {
                    showButton.configuration = .borderedTinted()
                }
                showButton.addTapGestureRecognizer {
                    let cubeGraphicVC = ScrambledCubeGraphicVC()
                    var cube = vc.cube
                    if let text = self.scrambleLabel.text, vc.cube == Cube() {
                        cube = cube.makeMoves(cube.convertStringToMoveList(scramble: text.dropFirst("Scramble\n\n".count).split(separator: " ").map { move in
                            String(move)
                        }))
                    } else {
                        cube = vc.cube
                    }
                    vc.cube = cube
                    
                    cubeGraphicVC.scramble = self.scrambleLabel.text ?? ""
                    cubeGraphicVC.cube = cube
                    cubeGraphicVC.rootVC = viewController
                    vc.modalPresentationStyle = .fullScreen
                    vc.navigationController?.pushViewController(cubeGraphicVC, animated: true)
                }
                                
                optionsBar.isUserInteractionEnabled = true
                optionsBar.backgroundColor = .clear
                optionsBar.addSubview(showButton)
                NSLayoutConstraint.activate([
                    showButton.centerXAnchor.constraint(equalTo: optionsBar.centerXAnchor),
                    showButton.centerYAnchor.constraint(equalTo: optionsBar.centerYAnchor, constant: CBConstants.UIConstants.defaultInsets),
                    showButton.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - CBConstants.UIConstants.defaultInsets)
                ])
                return optionsBar
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
            self.runningTimerLabel.attributedText = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: "Time: 00:00", size: .large)
            
            view.addSubview(containerView)
            containerView.addSubview(optionsBar)
            containerView.addSubview(timerButtonView)
            containerView.addSubview(scrambleLabel)
            containerView.addSubview(scrambleLengthSlider)
            containerView.addSubview(scrambleLengthLabel)
            timerButtonView.addSubview(runningTimerLabel)
            
            NSLayoutConstraint.activate(
                [
                    containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    
                    optionsBar.topAnchor.constraint(equalTo: containerView.topAnchor),
                    optionsBar.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                    optionsBar.heightAnchor.constraint(lessThanOrEqualToConstant: usingOptionsBar ? 100 : 0),
                    
                    scrambleLabel.topAnchor.constraint(equalTo: optionsBar.bottomAnchor, constant: CBConstants.UIConstants.doubleInset),
                    scrambleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: CBConstants.UIConstants.doubleInset),
                    scrambleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -CBConstants.UIConstants.doubleInset),
                    
                    timerButtonView.topAnchor.constraint(equalTo: optionsBar.bottomAnchor, constant: CBConstants.UIConstants.defaultInsetX4),
                    timerButtonView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    timerButtonView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                    
                    runningTimerLabel.centerXAnchor.constraint(equalTo: timerButtonView.centerXAnchor),
                    runningTimerLabel.topAnchor.constraint(equalTo: scrambleLabel.bottomAnchor, constant: 8),
                    
                    scrambleLengthLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                    scrambleLengthLabel.bottomAnchor.constraint(equalTo: scrambleLengthSlider.topAnchor, constant: -CBConstants.UIConstants.defaultInsets),
                    
                    scrambleLengthSlider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: CBConstants.UIConstants.doubleInset),
                    scrambleLengthSlider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -CBConstants.UIConstants.doubleInset),
                    scrambleLengthSlider.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -CBConstants.UIConstants.doubleInset),
                    scrambleLengthSlider.heightAnchor.constraint(equalToConstant: 30)
                ])
        }
    }
    
    static func createCubeGraphicView(for viewController: ScrambledCubeGraphicVC, with cube: Cube) {
        let presentingVC = viewController.presentingViewController as? TimerViewController
        var cubeCopy = presentingVC?.cube ?? cube
        let containerView = CBView()
        
        enum CubeFace: String {
            case up = "U"
            case down = "D"
            case back = "B"
            case front = "F"
            case left = "L"
            case right = "R"
        }
        
        func configureStackViewForFace(face: Surface, letter: CubeFace, hasBorder: Bool = true, cubeSize: CGFloat = 3) -> CBStackView {
            let stackView = CBStackView()
            
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.heightAnchor.constraint(equalToConstant: cubeSize * CBConstants.UIConstants.cubeTileDimension + CBConstants.UIConstants.defaultStackViewSpacing).isActive = true
            stackView.widthAnchor.constraint(equalToConstant: cubeSize * CBConstants.UIConstants.cubeTileDimension + CBConstants.UIConstants.defaultStackViewSpacing).isActive = true
            containerView.addSubview(stackView)
            
            for stack in 1...Int(cubeSize) {
                let hStack = CBStackView()
                hStack.axis = .horizontal
                hStack.distribution = .equalSpacing
                
                for square in 1...Int(cubeSize) {
                    let tileSquare = CBView()
                    tileSquare.backgroundColor = .black
                    tileSquare.widthAnchor.constraint(equalToConstant: CBConstants.UIConstants.cubeTileDimension).isActive = true
                    tileSquare.layer.borderColor = UIColor.CBTheme.secondary?.cgColor
                    tileSquare.layer.borderWidth = 2
                    tileSquare.layer.cornerRadius = 4
                    
                    createLetterForCenterTile(in: stackView, letter: letter.rawValue, on: .right)
                    createLetterForCenterTile(in: stackView, letter: letter.rawValue + "'", on: .left)
                    
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
                        print("invalid")
                    }
                    hStack.addArrangedSubview(tileSquare)
                }
                hStack.heightAnchor.constraint(equalToConstant: CBConstants.UIConstants.cubeTileDimension).isActive = true
                stackView.addArrangedSubview(hStack)
            }
            if hasBorder {
                stackView.layer.borderColor = UIColor.CBTheme.secondary?.cgColor
                stackView.layer.borderWidth = 3
            }
            return stackView
        }
        
        
        func configureTappableViewsForStack(stack: UIStackView, faceToTurn: CubeFace) {
            let leftTapView = CBView()
            stack.addSubview(leftTapView)
            leftTapView.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
            leftTapView.heightAnchor.constraint(equalTo: stack.heightAnchor).isActive = true
            leftTapView.widthAnchor.constraint(equalToConstant: CBConstants.UIConstants.cubeButtonWidth).isActive = true
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
                if cubeCopy == Cube() {
                    print("SOLVED")
                }
                viewController.cube = cubeCopy
                let timerVC = viewController.rootVC
                timerVC?.cube = cubeCopy
                viewController.updateCubeGraphic(with: cubeCopy)
            }
            let rightTapView = CBView()
            stack.addSubview(rightTapView)
            rightTapView.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
            rightTapView.heightAnchor.constraint(equalTo: stack.heightAnchor).isActive = true
            rightTapView.widthAnchor.constraint(equalToConstant: CBConstants.UIConstants.cubeButtonWidth).isActive = true
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
                if cubeCopy == Cube() {
                    print("SOLVED")
                }
                viewController.cube = cubeCopy
                let timerVC = viewController.rootVC
                timerVC?.cube = cubeCopy
                viewController.updateCubeGraphic(with: cubeCopy)
            }
        }
        
        // FACE STACKS
        let upFaceVStack = configureStackViewForFace(face: cubeCopy.up, letter: .up)
        configureTappableViewsForStack(stack: upFaceVStack, faceToTurn: .up)
        let frontFaceVStack = configureStackViewForFace(face: cubeCopy.front, letter: .front)
        configureTappableViewsForStack(stack: frontFaceVStack, faceToTurn: .front)
        let downFaceVStack = configureStackViewForFace(face: cubeCopy.down, letter: .down)
        configureTappableViewsForStack(stack: downFaceVStack, faceToTurn: .down)
        let leftFaceVStack = configureStackViewForFace(face: cubeCopy.left, letter: .left)
        configureTappableViewsForStack(stack: leftFaceVStack, faceToTurn: .left)
        let rightFaceVStack = configureStackViewForFace(face: cubeCopy.right, letter: .right)
        configureTappableViewsForStack(stack: rightFaceVStack, faceToTurn: .right)
        let backFaceVStack = configureStackViewForFace(face: cubeCopy.back, letter: .back)
        configureTappableViewsForStack(stack: backFaceVStack, faceToTurn: .back)
        
        guard let view = viewController.view else { return }
        
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate(
            [
                containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: CBConstants.UIConstants.defaultInsets),
                containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -CBConstants.UIConstants.defaultInsets),
                
                upFaceVStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                upFaceVStack.bottomAnchor.constraint(equalTo: frontFaceVStack.topAnchor, constant: -CBConstants.UIConstants.defaultInsets),
                
                frontFaceVStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                frontFaceVStack.bottomAnchor.constraint(equalTo: downFaceVStack.topAnchor, constant: -CBConstants.UIConstants.defaultInsets),
                
                leftFaceVStack.trailingAnchor.constraint(equalTo: frontFaceVStack.leadingAnchor, constant: -CBConstants.UIConstants.defaultInsets),
                leftFaceVStack.centerYAnchor.constraint(equalTo: frontFaceVStack.centerYAnchor),
                
                rightFaceVStack.leadingAnchor.constraint(equalTo: frontFaceVStack.trailingAnchor, constant: CBConstants.UIConstants.defaultInsets),
                rightFaceVStack.centerYAnchor.constraint(equalTo: frontFaceVStack.centerYAnchor),
                
                backFaceVStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: CBConstants.UIConstants.doubleInset),
                backFaceVStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -CBConstants.UIConstants.doubleInset),
                
                downFaceVStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                downFaceVStack.bottomAnchor.constraint(equalTo: backFaceVStack.topAnchor, constant: -CBConstants.UIConstants.defaultInsetX4)
            ])
    }
    
    enum PossibleSide {
        case left
        case right
    }
    static func createLetterForCenterTile(in stackView: UIStackView, letter: String, on side: PossibleSide) {
        let letterView = CBLabel()
        letterView.attributedText = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: letter, size: .small, color: .black)
        stackView.addSubview(letterView)
        letterView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
                
        switch side {
        case .right:
            letterView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -CBConstants.UIConstants.halfInset).isActive = true
        case .left:
            letterView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: CBConstants.UIConstants.halfInset).isActive = true
        }
    }
}
