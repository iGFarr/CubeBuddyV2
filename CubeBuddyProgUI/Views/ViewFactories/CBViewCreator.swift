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
            scrambleLengthLabel.attributedText = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: "Scramble Length: " + String(Int(scrambleLengthSlider.value)), size: .small)
            UserDefaults.standard.setValue(scrambleLengthSlider.value, forKey: UserDefaultsHelper.DefaultKeys.scrambleLength.rawValue)
            let scrambleText = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: CBBrain.getScramble(length: Int(scrambleLengthSlider.value)), size: .large)
            scrambleLabel.attributedText = scrambleText
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
            
            func createOptionsBar(for vc: TimerViewController) -> UIView {
                let optionsBar = CBView()
                let showButton = UIButton()
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
                
                showButton.translatesAutoresizingMaskIntoConstraints = false
                
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
            
            let containerView = UIView()
            var optionsBar = UIView()
            let timerButtonView = UIView()
            
            if usingOptionsBar {
                optionsBar = createOptionsBar(for: viewController)
            }
            timerButtonView.addTapGestureRecognizer {
                timerButtonViewPressed()
            }
            self.runningTimerLabel.attributedText = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: "Time: 00:00", size: .large)
            
            containerView.translatesAutoresizingMaskIntoConstraints = false
            timerButtonView.translatesAutoresizingMaskIntoConstraints = false
            
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
        let containerView = UIView()
        
        func configureStackViewForFace(face: Surface, letter: String) -> UIStackView {
            let stackView = UIStackView()
            
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.heightAnchor.constraint(equalToConstant: 90).isActive = true
            stackView.widthAnchor.constraint(equalToConstant: 90).isActive = true
            
            for stack in 1...3 {
                let hStack = UIStackView()
                hStack.translatesAutoresizingMaskIntoConstraints = false
                hStack.axis = .horizontal
                hStack.distribution = .equalSpacing
                for square in 1...3 {
                    let tileSquare = UIView()
                    tileSquare.backgroundColor = .black
                    tileSquare.translatesAutoresizingMaskIntoConstraints = false
                    tileSquare.widthAnchor.constraint(equalToConstant: 25).isActive = true
                    tileSquare.layer.borderColor = UIColor.CBTheme.secondary?.cgColor
                    tileSquare.layer.borderWidth = 2
                    tileSquare.layer.cornerRadius = 4
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
                            createLetterForCenterTile(for: tileSquare, letter: letter + "'")
                        }
                        if square == 2 {
                            tileSquare.backgroundColor = getColorForTile(tile: face.e)
                        }
                        if square == 3 {
                            tileSquare.backgroundColor = getColorForTile(tile: face.f)
                            createLetterForCenterTile(for: tileSquare, letter: letter)
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
                hStack.heightAnchor.constraint(equalToConstant: 25).isActive = true
                stackView.addArrangedSubview(hStack)
            }
            
            return stackView
        }
        
        enum CubeFace: String {
            case up = "U"
            case down = "D"
            case back = "B"
            case front = "F"
            case left = "L"
            case right = "R"
        }
        
        func configureTappableViewsForStack(stack: UIStackView, faceToTurn: CubeFace) {
            let leftTapView = CBView()
            stack.addSubview(leftTapView)
            leftTapView.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
            leftTapView.heightAnchor.constraint(equalTo: stack.heightAnchor).isActive = true
            leftTapView.widthAnchor.constraint(equalToConstant: 35).isActive = true
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
            rightTapView.widthAnchor.constraint(equalToConstant: 35).isActive = true
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
        let upFaceVStack = configureStackViewForFace(face: cubeCopy.up, letter: "U")
        configureTappableViewsForStack(stack: upFaceVStack, faceToTurn: .up)
        
        let frontFaceVStack = configureStackViewForFace(face: cubeCopy.front, letter: "F")
        configureTappableViewsForStack(stack: frontFaceVStack, faceToTurn: .front)
        frontFaceVStack.layer.borderColor = UIColor.CBTheme.secondary?.cgColor
        frontFaceVStack.layer.borderWidth = 3
        
        let downFaceVStack = configureStackViewForFace(face: cubeCopy.down, letter: "D")
        configureTappableViewsForStack(stack: downFaceVStack, faceToTurn: .down)
        
        let leftFaceVStack = configureStackViewForFace(face: cubeCopy.left, letter: "L")
        configureTappableViewsForStack(stack: leftFaceVStack, faceToTurn: .left)
        
        let rightFaceVStack = configureStackViewForFace(face: cubeCopy.right, letter: "R")
        configureTappableViewsForStack(stack: rightFaceVStack, faceToTurn: .right)
        
        let backFaceVStack = configureStackViewForFace(face: cubeCopy.back, letter: "B")
        configureTappableViewsForStack(stack: backFaceVStack, faceToTurn: .back)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        guard let view = viewController.view else { return }
        
        view.addSubview(containerView)
        containerView.addSubview(upFaceVStack)
        containerView.addSubview(frontFaceVStack)
        containerView.addSubview(downFaceVStack)
        containerView.addSubview(leftFaceVStack)
        containerView.addSubview(rightFaceVStack)
        containerView.addSubview(backFaceVStack)
        NSLayoutConstraint.activate(
            [
                containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: CBConstants.UIConstants.defaultInsets),
                containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -CBConstants.UIConstants.defaultInsets),
                
                upFaceVStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                upFaceVStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
                
                frontFaceVStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                frontFaceVStack.topAnchor.constraint(equalTo: upFaceVStack.bottomAnchor, constant: 6),
                
                downFaceVStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                downFaceVStack.topAnchor.constraint(equalTo: frontFaceVStack.bottomAnchor, constant: 6),
                
                leftFaceVStack.trailingAnchor.constraint(equalTo: frontFaceVStack.leadingAnchor, constant: -6),
                leftFaceVStack.centerYAnchor.constraint(equalTo: frontFaceVStack.centerYAnchor),
                
                rightFaceVStack.leadingAnchor.constraint(equalTo: frontFaceVStack.trailingAnchor, constant: 6),
                rightFaceVStack.centerYAnchor.constraint(equalTo: frontFaceVStack.centerYAnchor),
                
                backFaceVStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: CBConstants.UIConstants.doubleInset),
                backFaceVStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -CBConstants.UIConstants.doubleInset)
            ])
    }
    
    static func createLetterForCenterTile(for view: UIView, letter: String) {
        let letterView = UILabel()
        letterView.attributedText = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: letter, size: .small, color: .black)
        letterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(letterView)
        letterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        letterView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
