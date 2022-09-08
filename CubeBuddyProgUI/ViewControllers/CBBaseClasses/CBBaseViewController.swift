//
//  ViewController.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/1/22.
//

import UIKit

class CBBaseViewController: UIViewController {
    let AVHelper = CBAVHelper()
    lazy var soundsSwitchButton = CBButton()
    var soundsOn: Bool = UserDefaults.standard.bool(forKey: UserDefaultsHelper.DefaultKeys.soundsOn.rawValue) {
        didSet {
            UserDefaults.standard.set(soundsOn, forKey: UserDefaultsHelper.DefaultKeys.soundsOn.rawValue)
            soundsSwitchButton.removeFromSuperview()
            CBButtonCreator.configureSoundSwitchButton(for: self)
        }
    }
    lazy var explosionsOnSwitchButton = CBButton()
    var explosionsOn: Bool = UserDefaults.standard.bool(forKey: UserDefaultsHelper.DefaultKeys.explosionsOn.rawValue) {
        didSet {
            UserDefaults.standard.set(explosionsOn, forKey: UserDefaultsHelper.DefaultKeys.explosionsOn.rawValue)
            explosionsOnSwitchButton.removeFromSuperview()
            CBButtonCreator.configureExplosionsSwitchButton(for: self)
        }
    }
    lazy var cubeResetButton = CBButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.integer(forKey: UserDefaultsHelper.DefaultKeys.firstLoad.rawValue) == 0 {
            UserDefaults.standard.set(1, forKey: UserDefaultsHelper.DefaultKeys.firstLoad.rawValue)
            UserDefaults.standard.setValue(CBConstants.defaultScrambleSliderValue, forKey: UserDefaultsHelper.DefaultKeys.scrambleLength.rawValue)

            soundsOn = true
            explosionsOn = true
        }
        view.backgroundColor = .CBTheme.primary
    }
    
    override func viewWillLayoutSubviews() {
        view.frame = UIScreen.main.bounds
    }
}
    
