//
//  CBViewCreator.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/4/22.
//

import UIKit

class CBViewCreator {
    static func createCellSeparator(for cell: UITableViewCell) {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(view)
        view.heightAnchor.constraint(equalToConstant: CBConstants.UIConstants.cellSeparatorHeight).isActive = true
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - CBConstants.UIConstants.doubleInset).isActive = true
        view.centerYAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        view.backgroundColor = .CBTheme.secondary
    }
    class TimerView: UIView {
        var solves =  [Solve]()
        var timerRunning = false
        let runningTimerLabel: UILabel = UILabel()
        var timeElapsed = 0.00
        let timerTextColor: UIColor = .CBTheme.secondary ?? .systemGray
        let timerTextFont: UIFont = .CBFonts.returnCustomFont(size: 32)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.solves = UserDefaultsHelper.getAllObjects(named: .solves)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        func createTimerView(for viewController: CBBaseViewController, usingOptionsBar: Bool = false){
            let textAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: self.timerTextColor, .font: self.timerTextFont]
            
            func timerUpdatesUI(){
                self.timeElapsed += 0.01
                let hours = Int(self.timeElapsed) / 3600
                let hourString = String(hours)
                
                let minutes = Int(self.timeElapsed) / 60
                var minuteString = String(minutes)
                
                let seconds = Int(self.timeElapsed) % 60
                var secondString = String(seconds)
                
                let useHours = hours != 0
                let useMinutes = useHours || (minutes != 0)
                
                let milliseconds = Int(self.timeElapsed * 100)
                let msToHundredths = milliseconds % 100
                var milliString = String(msToHundredths)
                
                if minutes < 10 {
                    minuteString = "0" + minuteString
                }
                if seconds < 10 {
                    secondString = "0" + secondString
                }
                if msToHundredths < 10 {
                    milliString = "0" + String(msToHundredths)
                }
                
                let formattedTimerString = "Time: \(useHours ? (hourString + ":"): "")\(useMinutes ? (minuteString + ":") : "")\(secondString):\(milliString)"
                self.runningTimerLabel.attributedText = NSAttributedString(string: formattedTimerString, attributes: textAttributes)
            }
    
            let scrambleLabel = UILabel()
            let scrambleText = NSAttributedString(string: CBBrain.getScramble(), attributes: textAttributes)
            scrambleLabel.attributedText = scrambleText
            scrambleLabel.numberOfLines = 0
            scrambleLabel.lineBreakMode = .byWordWrapping
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
                    scrambleLabel.attributedText = NSAttributedString(string: CBBrain.getScramble(), attributes: textAttributes)
                    self.timerRunning = false
                    self.timeElapsed = 0.00
                }
            }
            
            func createOptionsBar(for vc: CBBaseViewController) -> UIView {
                let optionsBar = UIView()
                let showButton = UIButton()
                let buttonText = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: "Show me the cube!", size: 32)

                showButton.layer.cornerRadius = CBConstants.UIConstants.buttonCornerRadius
                showButton.layer.borderColor = UIColor.CBTheme.secondary?.cgColor
                showButton.layer.borderWidth = 2
                showButton.setAttributedTitle(buttonText, for: .normal)
                if #available(iOS 15.0, *) {
                    showButton.configuration = .borderedTinted()
                }
                showButton.addTapGestureRecognizer {
                    let cubeGraphicVC = ScrambledCubeGraphicVC()
                    cubeGraphicVC.scramble = scrambleLabel.text ?? ""
                    vc.modalPresentationStyle = .fullScreen
                    vc.navigationController?.pushViewController(cubeGraphicVC, animated: true)
                }
                
                showButton.translatesAutoresizingMaskIntoConstraints = false

                optionsBar.translatesAutoresizingMaskIntoConstraints = false
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
            
            self.runningTimerLabel.attributedText = NSAttributedString(string: "Time: 00:00", attributes: textAttributes)
            
            containerView.translatesAutoresizingMaskIntoConstraints = false
            timerButtonView.translatesAutoresizingMaskIntoConstraints = false
            scrambleLabel.translatesAutoresizingMaskIntoConstraints = false
            runningTimerLabel.translatesAutoresizingMaskIntoConstraints = false
            
            
            view.addSubview(containerView)
            containerView.addSubview(optionsBar)
            containerView.addSubview(timerButtonView)
            containerView.addSubview(scrambleLabel)
            timerButtonView.addSubview(runningTimerLabel)
            
            NSLayoutConstraint.activate(
            [
                containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                
                optionsBar.topAnchor.constraint(equalTo: containerView.topAnchor),
                optionsBar.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                optionsBar.heightAnchor.constraint(equalToConstant: usingOptionsBar ? 60 : 0),
                
                scrambleLabel.topAnchor.constraint(equalTo: optionsBar.bottomAnchor, constant: CBConstants.UIConstants.doubleInset),
                scrambleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: CBConstants.UIConstants.doubleInset),
                scrambleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -CBConstants.UIConstants.doubleInset),
                
                timerButtonView.topAnchor.constraint(equalTo: optionsBar.bottomAnchor),
                timerButtonView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                timerButtonView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                
                runningTimerLabel.centerXAnchor.constraint(equalTo: timerButtonView.centerXAnchor),
                runningTimerLabel.topAnchor.constraint(equalTo: scrambleLabel.bottomAnchor, constant: 8)
            ])
        }
    }
    
    static func createCubeGraphicView(for viewController: ScrambledCubeGraphicVC, with cube: Cube) {
        var cubeCopy = cube
        let containerView = UIView()
        
        
        // UP FACE STACKS
        let upFaceVStack = UIStackView()
        upFaceVStack.axis = .vertical
        upFaceVStack.distribution = .equalSpacing
        upFaceVStack.translatesAutoresizingMaskIntoConstraints = false
        
        for stack in 1...3 {
            let upFaceStack = UIStackView()
            upFaceStack.translatesAutoresizingMaskIntoConstraints = false
            upFaceStack.axis = .horizontal
            upFaceStack.distribution = .equalSpacing
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
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.up.a)
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.up.b)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.up.c)
                    }
                case 2:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.up.d)
                        createLetterForCenterTile(for: tileSquare, letter: "U'")
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.up.e)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.up.f)
                        createLetterForCenterTile(for: tileSquare, letter: "U")
                    }
                case 3:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.up.g)
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.up.h)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.up.i)
                    }
                default:
                    print("invalid")
                }
                upFaceStack.addArrangedSubview(tileSquare)
            }
            upFaceStack.heightAnchor.constraint(equalToConstant: 25).isActive = true
            upFaceVStack.addArrangedSubview(upFaceStack)
        }
        var leftTapView = UIView()
        leftTapView.translatesAutoresizingMaskIntoConstraints = false
        upFaceVStack.addSubview(leftTapView)
        leftTapView.leadingAnchor.constraint(equalTo: upFaceVStack.leadingAnchor).isActive = true
        leftTapView.heightAnchor.constraint(equalTo: upFaceVStack.heightAnchor).isActive = true
        leftTapView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        leftTapView.addTapGestureRecognizer {
            cubeCopy = cubeCopy.makeUp(.counterclockwise)
            viewController.updateCubeGraphic(with: cubeCopy)
        }
        var rightTapView = UIView()
        rightTapView.translatesAutoresizingMaskIntoConstraints = false
        upFaceVStack.addSubview(rightTapView)
        rightTapView.trailingAnchor.constraint(equalTo: upFaceVStack.trailingAnchor).isActive = true
        rightTapView.heightAnchor.constraint(equalTo: upFaceVStack.heightAnchor).isActive = true
        rightTapView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        rightTapView.addTapGestureRecognizer {
            cubeCopy = cubeCopy.makeUp(.clockwise)
            viewController.updateCubeGraphic(with: cubeCopy)
        }
        var separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        upFaceVStack.addSubview(separator)
        separator.heightAnchor.constraint(equalToConstant: CBConstants.UIConstants.cellSeparatorHeight).isActive = true
        separator.topAnchor.constraint(equalTo: upFaceVStack.bottomAnchor, constant: 2).isActive = true
        separator.widthAnchor.constraint(equalTo: upFaceVStack.widthAnchor, constant: 4).isActive = true
        separator.centerXAnchor.constraint(equalTo: upFaceVStack.centerXAnchor).isActive = true
        separator.backgroundColor = .CBTheme.secondary
        
        
        // FRONT FACE STACKS
        let frontFaceVStack = UIStackView()
        frontFaceVStack.axis = .vertical
        frontFaceVStack.distribution = .equalSpacing
        frontFaceVStack.translatesAutoresizingMaskIntoConstraints = false
        
        for stack in 1...3 {
            let frontFaceStack = UIStackView()
            frontFaceStack.translatesAutoresizingMaskIntoConstraints = false
            frontFaceStack.axis = .horizontal
            frontFaceStack.distribution = .equalSpacing
            for square in 1...3 {
                let tileSquare = UIView()
                tileSquare.backgroundColor = .blue
                tileSquare.translatesAutoresizingMaskIntoConstraints = false
                tileSquare.widthAnchor.constraint(equalToConstant: 25).isActive = true
                tileSquare.layer.borderColor = UIColor.CBTheme.secondary?.cgColor
                tileSquare.layer.borderWidth = 2
                tileSquare.layer.cornerRadius = 4
                switch stack {
                case 1:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.front.a)
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.front.b)

                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.front.c)
                    }
                case 2:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.front.d)
                        createLetterForCenterTile(for: tileSquare, letter: "F'")
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.front.e)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.front.f)
                        createLetterForCenterTile(for: tileSquare, letter: "F")
                    }
                case 3:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.front.g)
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.front.h)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.front.i)
                    }
                default:
                    print("invalid")
                }
                frontFaceStack.addArrangedSubview(tileSquare)
            }
            frontFaceStack.heightAnchor.constraint(equalToConstant: 25).isActive = true
            frontFaceVStack.addArrangedSubview(frontFaceStack)
        }
        leftTapView = UIView()
        leftTapView.translatesAutoresizingMaskIntoConstraints = false
        frontFaceVStack.addSubview(leftTapView)
        leftTapView.leadingAnchor.constraint(equalTo: frontFaceVStack.leadingAnchor).isActive = true
        leftTapView.heightAnchor.constraint(equalTo: frontFaceVStack.heightAnchor).isActive = true
        leftTapView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        leftTapView.addTapGestureRecognizer {
            cubeCopy = cubeCopy.makeFront(.counterclockwise)
            viewController.updateCubeGraphic(with: cubeCopy)
        }
        rightTapView = UIView()
        rightTapView.translatesAutoresizingMaskIntoConstraints = false
        frontFaceVStack.addSubview(rightTapView)
        rightTapView.trailingAnchor.constraint(equalTo: frontFaceVStack.trailingAnchor).isActive = true
        rightTapView.heightAnchor.constraint(equalTo: frontFaceVStack.heightAnchor).isActive = true
        rightTapView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        rightTapView.addTapGestureRecognizer {
            cubeCopy = cubeCopy.makeFront(.clockwise)
            viewController.updateCubeGraphic(with: cubeCopy)
        }
        separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        frontFaceVStack.addSubview(separator)
        separator.heightAnchor.constraint(equalToConstant: CBConstants.UIConstants.cellSeparatorHeight).isActive = true
        separator.topAnchor.constraint(equalTo: frontFaceVStack.bottomAnchor, constant: 2).isActive = true
        separator.widthAnchor.constraint(equalTo: frontFaceVStack.widthAnchor, constant: 4).isActive = true
        separator.centerXAnchor.constraint(equalTo: frontFaceVStack.centerXAnchor).isActive = true
        separator.backgroundColor = .CBTheme.secondary
        
        // Down FACE STACKS
        let downFaceVStack = UIStackView()
        downFaceVStack.axis = .vertical
        downFaceVStack.distribution = .equalSpacing
        downFaceVStack.translatesAutoresizingMaskIntoConstraints = false
        
        for stack in 1...3 {
            let downFaceStack = UIStackView()
            downFaceStack.translatesAutoresizingMaskIntoConstraints = false
            downFaceStack.axis = .horizontal
            downFaceStack.distribution = .equalSpacing
            for square in 1...3 {
                let tileSquare = UIView()
                tileSquare.backgroundColor = .blue
                tileSquare.translatesAutoresizingMaskIntoConstraints = false
                tileSquare.widthAnchor.constraint(equalToConstant: 25).isActive = true
                tileSquare.layer.borderColor = UIColor.CBTheme.secondary?.cgColor
                tileSquare.layer.borderWidth = 2
                tileSquare.layer.cornerRadius = 4
                switch stack {
                case 1:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.down.a)
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.down.b)

                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.down.c)
                    }
                case 2:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.down.d)
                        createLetterForCenterTile(for: tileSquare, letter: "D'")
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.down.e)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.down.f)
                        createLetterForCenterTile(for: tileSquare, letter: "D")
                    }
                case 3:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.down.g)
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.down.h)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.down.i)
                    }
                default:
                    print("invalid")
                }
                downFaceStack.addArrangedSubview(tileSquare)
            }
            downFaceStack.heightAnchor.constraint(equalToConstant: 25).isActive = true
            downFaceVStack.addArrangedSubview(downFaceStack)
        }
        leftTapView = UIView()
        leftTapView.translatesAutoresizingMaskIntoConstraints = false
        downFaceVStack.addSubview(leftTapView)
        leftTapView.leadingAnchor.constraint(equalTo: downFaceVStack.leadingAnchor).isActive = true
        leftTapView.heightAnchor.constraint(equalTo: downFaceVStack.heightAnchor).isActive = true
        leftTapView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        leftTapView.addTapGestureRecognizer {
            cubeCopy = cubeCopy.makeDown(.counterclockwise)
            viewController.updateCubeGraphic(with: cubeCopy)
        }
        rightTapView = UIView()
        rightTapView.translatesAutoresizingMaskIntoConstraints = false
        downFaceVStack.addSubview(rightTapView)
        rightTapView.trailingAnchor.constraint(equalTo: downFaceVStack.trailingAnchor).isActive = true
        rightTapView.heightAnchor.constraint(equalTo: downFaceVStack.heightAnchor).isActive = true
        rightTapView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        rightTapView.addTapGestureRecognizer {
            cubeCopy = cubeCopy.makeDown(.clockwise)
            viewController.updateCubeGraphic(with: cubeCopy)
        }
        
        // LEFT FACE STACKS
        let leftFaceVStack = UIStackView()
        leftFaceVStack.axis = .vertical
        leftFaceVStack.distribution = .equalSpacing
        leftFaceVStack.translatesAutoresizingMaskIntoConstraints = false
        
        for stack in 1...3 {
            let leftFaceStack = UIStackView()
            leftFaceStack.translatesAutoresizingMaskIntoConstraints = false
            leftFaceStack.axis = .horizontal
            leftFaceStack.distribution = .equalSpacing
            for square in 1...3 {
                let tileSquare = UIView()
                tileSquare.backgroundColor = .blue
                tileSquare.translatesAutoresizingMaskIntoConstraints = false
                tileSquare.widthAnchor.constraint(equalToConstant: 25).isActive = true
                tileSquare.layer.borderColor = UIColor.CBTheme.secondary?.cgColor
                tileSquare.layer.borderWidth = 2
                tileSquare.layer.cornerRadius = 4
                switch stack {
                case 1:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.left.a)
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.left.b)

                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.left.c)
                    }
                case 2:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.left.d)
                        createLetterForCenterTile(for: tileSquare, letter: "L'")
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.left.e)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.left.f)
                        createLetterForCenterTile(for: tileSquare, letter: "L")
                    }
                case 3:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.left.g)
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.left.h)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.left.i)
                    }
                default:
                    print("invalid")
                }
                leftFaceStack.addArrangedSubview(tileSquare)
            }
            leftFaceStack.heightAnchor.constraint(equalToConstant: 25).isActive = true
            leftFaceVStack.addArrangedSubview(leftFaceStack)
        }
        leftTapView = UIView()
        leftTapView.translatesAutoresizingMaskIntoConstraints = false
        leftFaceVStack.addSubview(leftTapView)
        leftTapView.leadingAnchor.constraint(equalTo: leftFaceVStack.leadingAnchor).isActive = true
        leftTapView.heightAnchor.constraint(equalTo: leftFaceVStack.heightAnchor).isActive = true
        leftTapView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        leftTapView.addTapGestureRecognizer {
            cubeCopy = cubeCopy.makeLeft(.counterclockwise)
            viewController.updateCubeGraphic(with: cubeCopy)
        }
        rightTapView = UIView()
        rightTapView.translatesAutoresizingMaskIntoConstraints = false
        leftFaceVStack.addSubview(rightTapView)
        rightTapView.trailingAnchor.constraint(equalTo: leftFaceVStack.trailingAnchor).isActive = true
        rightTapView.heightAnchor.constraint(equalTo: leftFaceVStack.heightAnchor).isActive = true
        rightTapView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        rightTapView.addTapGestureRecognizer {
            cubeCopy = cubeCopy.makeLeft(.clockwise)
            viewController.updateCubeGraphic(with: cubeCopy)
        }
        separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        leftFaceVStack.addSubview(separator)
        separator.widthAnchor.constraint(equalToConstant: CBConstants.UIConstants.cellSeparatorHeight).isActive = true
        separator.trailingAnchor.constraint(equalTo: leftFaceVStack.trailingAnchor, constant: 4).isActive = true
        separator.heightAnchor.constraint(equalTo: leftFaceVStack.heightAnchor, constant: 4).isActive = true
        separator.centerYAnchor.constraint(equalTo: leftFaceVStack.centerYAnchor).isActive = true
        separator.backgroundColor = .CBTheme.secondary
        
        // RIGHT FACE STACKS
        let rightFaceVStack = UIStackView()
        rightFaceVStack.axis = .vertical
        rightFaceVStack.distribution = .equalSpacing
        rightFaceVStack.translatesAutoresizingMaskIntoConstraints = false
        
        for stack in 1...3 {
            let rightFaceStack = UIStackView()
            rightFaceStack.translatesAutoresizingMaskIntoConstraints = false
            rightFaceStack.axis = .horizontal
            rightFaceStack.distribution = .equalSpacing
            for square in 1...3 {
                let tileSquare = UIView()
                tileSquare.backgroundColor = .blue
                tileSquare.translatesAutoresizingMaskIntoConstraints = false
                tileSquare.widthAnchor.constraint(equalToConstant: 25).isActive = true
                tileSquare.layer.borderColor = UIColor.CBTheme.secondary?.cgColor
                tileSquare.layer.borderWidth = 2
                tileSquare.layer.cornerRadius = 4
                switch stack {
                case 1:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.right.a)
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.right.b)

                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.right.c)
                    }
                case 2:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.right.d)
                        createLetterForCenterTile(for: tileSquare, letter: "R'")
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.right.e)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.right.f)
                        createLetterForCenterTile(for: tileSquare, letter: "R")
                    }
                case 3:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.right.g)
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.right.h)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.right.i)
                    }
                default:
                    print("invalid")
                }
                rightFaceStack.addArrangedSubview(tileSquare)
            }
            rightFaceStack.heightAnchor.constraint(equalToConstant: 25).isActive = true
            rightFaceVStack.addArrangedSubview(rightFaceStack)
        }
        leftTapView = UIView()
        leftTapView.translatesAutoresizingMaskIntoConstraints = false
        rightFaceVStack.addSubview(leftTapView)
        leftTapView.leadingAnchor.constraint(equalTo: rightFaceVStack.leadingAnchor).isActive = true
        leftTapView.heightAnchor.constraint(equalTo: rightFaceVStack.heightAnchor).isActive = true
        leftTapView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        leftTapView.addTapGestureRecognizer {
            cubeCopy = cubeCopy.makeRight(.counterclockwise)
            viewController.updateCubeGraphic(with: cubeCopy)
        }
        rightTapView = UIView()
        rightTapView.translatesAutoresizingMaskIntoConstraints = false
        rightFaceVStack.addSubview(rightTapView)
        rightTapView.trailingAnchor.constraint(equalTo: rightFaceVStack.trailingAnchor).isActive = true
        rightTapView.heightAnchor.constraint(equalTo: rightFaceVStack.heightAnchor).isActive = true
        rightTapView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        rightTapView.addTapGestureRecognizer {
            cubeCopy = cubeCopy.makeRight(.clockwise)
            viewController.updateCubeGraphic(with: cubeCopy)
        }
        separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        rightFaceVStack.addSubview(separator)
        separator.widthAnchor.constraint(equalToConstant: CBConstants.UIConstants.cellSeparatorHeight).isActive = true
        separator.leadingAnchor.constraint(equalTo: rightFaceVStack.leadingAnchor, constant: -4).isActive = true
        separator.heightAnchor.constraint(equalTo: rightFaceVStack.heightAnchor, constant: 4).isActive = true
        separator.centerYAnchor.constraint(equalTo: rightFaceVStack.centerYAnchor).isActive = true
        separator.backgroundColor = .CBTheme.secondary
        containerView.translatesAutoresizingMaskIntoConstraints = false
        guard let view = viewController.view else { return }

        // BACK FACE STACKS
        let backFaceVStack = UIStackView()
        backFaceVStack.axis = .vertical
        backFaceVStack.distribution = .equalSpacing
        backFaceVStack.translatesAutoresizingMaskIntoConstraints = false
        
        for stack in 1...3 {
            let backFaceStack = UIStackView()
            backFaceStack.translatesAutoresizingMaskIntoConstraints = false
            backFaceStack.axis = .horizontal
            backFaceStack.distribution = .equalSpacing
            for square in 1...3 {
                let tileSquare = UIView()
                tileSquare.backgroundColor = .blue
                tileSquare.translatesAutoresizingMaskIntoConstraints = false
                tileSquare.widthAnchor.constraint(equalToConstant: 25).isActive = true
                tileSquare.layer.borderColor = UIColor.CBTheme.secondary?.cgColor
                tileSquare.layer.borderWidth = 2
                tileSquare.layer.cornerRadius = 4
                switch stack {
                case 1:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.back.a)
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.back.b)

                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.back.c)
                    }
                case 2:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.back.d)
                        createLetterForCenterTile(for: tileSquare, letter: "B'")
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.back.e)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.back.f)
                        createLetterForCenterTile(for: tileSquare, letter: "B")
                    }
                case 3:
                    if square == 1 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.back.g)
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.back.h)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.back.i)
                    }
                default:
                    print("invalid")
                }
                backFaceStack.addArrangedSubview(tileSquare)
            }
            backFaceStack.heightAnchor.constraint(equalToConstant: 25).isActive = true
            backFaceVStack.addArrangedSubview(backFaceStack)
        }
        leftTapView = UIView()
        leftTapView.translatesAutoresizingMaskIntoConstraints = false
        backFaceVStack.addSubview(leftTapView)
        leftTapView.leadingAnchor.constraint(equalTo: backFaceVStack.leadingAnchor).isActive = true
        leftTapView.heightAnchor.constraint(equalTo: backFaceVStack.heightAnchor).isActive = true
        leftTapView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        leftTapView.addTapGestureRecognizer {
            cubeCopy = cubeCopy.makeBack(.counterclockwise)
            viewController.updateCubeGraphic(with: cubeCopy)
        }
        rightTapView = UIView()
        rightTapView.translatesAutoresizingMaskIntoConstraints = false
        backFaceVStack.addSubview(rightTapView)
        rightTapView.trailingAnchor.constraint(equalTo: backFaceVStack.trailingAnchor).isActive = true
        rightTapView.heightAnchor.constraint(equalTo: backFaceVStack.heightAnchor).isActive = true
        rightTapView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        rightTapView.addTapGestureRecognizer {
            cubeCopy = cubeCopy.makeRight(.clockwise)
            viewController.updateCubeGraphic(with: cubeCopy)
        }
        
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
            upFaceVStack.widthAnchor.constraint(equalToConstant: 90),
            upFaceVStack.heightAnchor.constraint(equalToConstant: 90),
            upFaceVStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            
            frontFaceVStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            frontFaceVStack.widthAnchor.constraint(equalToConstant: 90),
            frontFaceVStack.heightAnchor.constraint(equalToConstant: 90),
            frontFaceVStack.topAnchor.constraint(equalTo: upFaceVStack.bottomAnchor, constant: 6),
            
            downFaceVStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            downFaceVStack.widthAnchor.constraint(equalToConstant: 90),
            downFaceVStack.heightAnchor.constraint(equalToConstant: 90),
            downFaceVStack.topAnchor.constraint(equalTo: frontFaceVStack.bottomAnchor, constant: 6),
            
            leftFaceVStack.trailingAnchor.constraint(equalTo: frontFaceVStack.leadingAnchor, constant: -6),
            leftFaceVStack.widthAnchor.constraint(equalToConstant: 90),
            leftFaceVStack.heightAnchor.constraint(equalToConstant: 90),
            leftFaceVStack.centerYAnchor.constraint(equalTo: frontFaceVStack.centerYAnchor),
            
            rightFaceVStack.leadingAnchor.constraint(equalTo: frontFaceVStack.trailingAnchor, constant: 6),
            rightFaceVStack.widthAnchor.constraint(equalToConstant: 90),
            rightFaceVStack.heightAnchor.constraint(equalToConstant: 90),
            rightFaceVStack.centerYAnchor.constraint(equalTo: frontFaceVStack.centerYAnchor),
            
            backFaceVStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: CBConstants.UIConstants.doubleInset),
            backFaceVStack.widthAnchor.constraint(equalToConstant: 90),
            backFaceVStack.heightAnchor.constraint(equalToConstant: 90),
            backFaceVStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -CBConstants.UIConstants.doubleInset)
        ])
    }
    static func createLetterForCenterTile(for view: UIView, letter: String) {
        let letterView = UILabel()
        letterView.attributedText = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: letter, size: 16, color: .black)
        letterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(letterView)
        letterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        letterView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}
