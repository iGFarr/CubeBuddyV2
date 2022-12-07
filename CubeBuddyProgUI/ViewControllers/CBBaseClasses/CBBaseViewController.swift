//
//  ViewController.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/1/22.
//

import UIKit

class CBBaseViewController: UIViewController {
    lazy var AVHelper: CBAVHelper = CBAVHelper()
    lazy var soundsSwitchButton = CBButton()
    var soundsOn: Bool = UserDefaultsHelper.getBoolForKeyIfPresent(key: .soundsOn) {
        didSet {
            UserDefaultsHelper.setBoolFor(key: .soundsOn, value: soundsOn)
            soundsSwitchButton.removeFromSuperview()
            CBButtonCreator.configureSoundSwitchButton(for: self)
        }
    }
    lazy var explosionsOnSwitchButton = CBButton()
    var explosionsOn: Bool = UserDefaultsHelper.getBoolForKeyIfPresent(key: .explosionsOn) {
        didSet {
            UserDefaultsHelper.setBoolFor(key: .explosionsOn, value: explosionsOn)
            explosionsOnSwitchButton.removeFromSuperview()
            CBButtonCreator.configureExplosionsSwitchButton(for: self)
        }
    }
    lazy var cubeResetButton = CBButton()
    lazy var present3DButton = CBButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // This block will execute on first load to set defaults
        if UserDefaultsHelper.getIntForKeyIfPresent(key: .firstLoad) == 0 {
            UserDefaultsHelper.setIntFor(key: .firstLoad, value: 1)
            UserDefaultsHelper.setFloatFor(key: .scrambleLength, value: CBConstants.defaultScrambleSliderValue)
            UserDefaultsHelper.setDoubleFor(key: .customAvgX, value: 12.0)
            UserDefaultsHelper.setIntFor(key: .selectedSession, value: 1)
            soundsOn = true
            explosionsOn = true
        }
        view.backgroundColor = .CBTheme.primary
    }
    
    override func viewWillLayoutSubviews() {
        view.frame = UIScreen.main.bounds
    }
}
    
