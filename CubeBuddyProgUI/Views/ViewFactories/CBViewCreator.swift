//
//  CBViewCreator.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/4/22.
//

import UIKit

class CBViewCreator {
    class func createCellSeparator(for cell: UITableViewCell) {
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
                    showButton.heightAnchor.constraint(equalToConstant: 50),
                    showButton.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - CBConstants.UIConstants.defaultInsetX4)
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
    
    class func createCubeGraphicView(for viewController: CBBaseViewController, with cube: Cube) {
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
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.up.e)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.up.f)
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
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        upFaceVStack.addSubview(separator)
        separator.heightAnchor.constraint(equalToConstant: CBConstants.UIConstants.cellSeparatorHeight).isActive = true
        separator.topAnchor.constraint(equalTo: upFaceVStack.bottomAnchor, constant: 2).isActive = true
        separator.widthAnchor.constraint(equalTo: upFaceVStack.widthAnchor).isActive = true
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
                    }
                    if square == 2 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.front.e)
                    }
                    if square == 3 {
                        tileSquare.backgroundColor = getColorForTile(tile: cubeCopy.front.f)
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
        let middleSeparator = UIView()
        middleSeparator.translatesAutoresizingMaskIntoConstraints = false
        frontFaceVStack.addSubview(middleSeparator)
        middleSeparator.heightAnchor.constraint(equalToConstant: CBConstants.UIConstants.cellSeparatorHeight).isActive = true
        middleSeparator.topAnchor.constraint(equalTo: frontFaceVStack.bottomAnchor, constant: 2).isActive = true
        middleSeparator.widthAnchor.constraint(equalTo: frontFaceVStack.widthAnchor).isActive = true
        middleSeparator.backgroundColor = .CBTheme.secondary
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        guard let view = viewController.view else { return }

        view.addSubview(containerView)
        containerView.addSubview(upFaceVStack)
        containerView.addSubview(frontFaceVStack)
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
            frontFaceVStack.topAnchor.constraint(equalTo: upFaceVStack.bottomAnchor, constant: 6)
        ])
    }
}
