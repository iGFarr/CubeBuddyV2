//
//  ViewController.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/1/22.
//

import UIKit

class CBBaseViewController: UIViewController {
    var soundsSwitchButton = CBButton()
    var soundsOn: Bool = UserDefaults.standard.bool(forKey: UserDefaultsHelper.DefaultKeys.soundsOn.rawValue) {
        didSet {
            UserDefaults.standard.set(soundsOn, forKey: UserDefaultsHelper.DefaultKeys.soundsOn.rawValue)
            soundsSwitchButton.removeFromSuperview()
            CBViewCreator.configureSoundSwitchButton(for: self)
        }
    }
    var explosionsOnSwitchButton = CBButton()
    var explosionsOn: Bool = UserDefaults.standard.bool(forKey: UserDefaultsHelper.DefaultKeys.explosionsOn.rawValue) {
        didSet {
            UserDefaults.standard.set(explosionsOn, forKey: UserDefaultsHelper.DefaultKeys.explosionsOn.rawValue)
            explosionsOnSwitchButton.removeFromSuperview()
            CBViewCreator.configureExplosionsSwitchButton(for: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.integer(forKey: UserDefaultsHelper.DefaultKeys.firstLoad.rawValue) == 0 {
            UserDefaults.standard.set(1, forKey: UserDefaultsHelper.DefaultKeys.firstLoad.rawValue)
            UserDefaults.standard.set(true, forKey: UserDefaultsHelper.DefaultKeys.soundsOn.rawValue)
            soundsOn = true
        }
        view.backgroundColor = .CBTheme.primary
    }
}
    
