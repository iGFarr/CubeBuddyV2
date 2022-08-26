//
//  CBViewCreator.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/4/22.
//

import UIKit

class CBViewCreator {
    
    class func createOptionsBar() -> UIView {
        let optionsBar = UIView()
        optionsBar.translatesAutoresizingMaskIntoConstraints = false
        optionsBar.isUserInteractionEnabled = true
        optionsBar.backgroundColor = .systemGray
        return optionsBar
    }
    
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
        let timerTextFont: UIFont = .CBFonts.primary.withSize(32)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.solves = UserDefaultsHelper.getAllObjects(named: "solves")
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
                    let newSolve = Solve(scramble: scrambleLabel.text ?? "No scramble", time: runningTimerLabel.text ?? "No timer", puzzle: "3 x 3")
                    self.solves.append(newSolve)
                    UserDefaultsHelper.saveAllObjects(allObjects: solves, named: "solves")
                    print(solves.count)
                    scrambleLabel.attributedText = NSAttributedString(string: CBBrain.getScramble(), attributes: textAttributes)
                    self.timerRunning = false
                    self.timeElapsed = 0.00
                }
            }
            
            guard let view = viewController.view else { return }

            let containerView = UIView()
            var optionsBar = UIView()
            let timerButtonView = UIView()
            
            if usingOptionsBar {
                optionsBar = CBViewCreator.createOptionsBar()
            }
            timerButtonView.addTapGestureRecognizer {
                timerButtonViewPressed()
            }
            
            self.runningTimerLabel.attributedText = NSAttributedString(string: "Time: 00:00", attributes: textAttributes)
            optionsBar.backgroundColor = .systemGray
            
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
                
                scrambleLabel.topAnchor.constraint(equalTo: optionsBar.bottomAnchor, constant: 16),
                scrambleLabel.bottomAnchor.constraint(lessThanOrEqualTo: runningTimerLabel.topAnchor, constant: -32),
                scrambleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                scrambleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                
                timerButtonView.topAnchor.constraint(equalTo: optionsBar.bottomAnchor),
                timerButtonView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                timerButtonView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                
                runningTimerLabel.centerXAnchor.constraint(equalTo: timerButtonView.centerXAnchor),
                runningTimerLabel.centerYAnchor.constraint(equalTo: timerButtonView.centerYAnchor)
            ])
        }
    }
    
}
