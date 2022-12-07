//
//  CBButtonCreator.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 9/5/22.
//

import UIKit

class CBButtonCreator {
    static func configureCubeResetButton(for vc: CBBaseViewController, size: CGFloat = CBConstants.UI.defaultButtonSize){
        let cubeResetButton = CBButton()
        guard let delegate = vc as? CubeDelegate else { return }
        cubeResetButton.heightConstant(size)
        cubeResetButton.widthConstant(size)
        cubeResetButton.setBackgroundImage(UIImage(systemName: "circle.grid.3x3.fill"), for: .normal)
        cubeResetButton.tintColor = delegate.cube == Cube() ? (.CBTheme.secondary ?? .systemGreen) :  .systemRed
        cubeResetButton.addTapGestureRecognizer {
            if delegate.cube != Cube() {
                delegate.cancelUpdate()
                delegate.updateCube(cube: Cube())
            } else {
                delegate.cancelUpdate()
                var scrambledCube = Cube()
                scrambledCube = CBBrain.makeMovesFromString(cube: scrambledCube, text: CBBrain.getScramble(length: 30))
                delegate.updateCube(cube: scrambledCube)
            }
        }
        cubeResetButton.constrainToEdgePosition(.topCenter, in: vc.view, safeArea: true)
        vc.cubeResetButton = cubeResetButton
    }
    
    static func configureSoundSwitchButton(for vc: CBBaseViewController, size: CGFloat = CBConstants.UI.defaultButtonSize){
        let soundSwitchButton = CBButton()
        soundSwitchButton.heightConstant(size)
        soundSwitchButton.widthConstant(size)
        if vc.soundsOn {
            soundSwitchButton.setBackgroundImage(UIImage(systemName: "speaker.fill"), for: .normal)
        } else {
            soundSwitchButton.setBackgroundImage(UIImage(systemName: "speaker"), for: .normal)
        }
        soundSwitchButton.tintColor = .CBTheme.secondary ?? .systemGreen
        soundSwitchButton.addTapGestureRecognizer {
            if vc.soundsOn {
                vc.AVHelper.player.stop()
            }
            vc.soundsOn.toggle()
        }
        soundSwitchButton.constrainToEdgePosition(.topLeft, in: vc.view, safeArea: true)
        vc.soundsSwitchButton = soundSwitchButton
    }
    
    static func configureExplosionsSwitchButton(for vc: CBBaseViewController, size: CGFloat = CBConstants.UI.defaultButtonSize){
        let explosionsSwitchButton = CBButton()
        explosionsSwitchButton.heightConstant(size)
        explosionsSwitchButton.widthConstant(size)
        if vc.explosionsOn {
            explosionsSwitchButton.setBackgroundImage(UIImage(systemName: "atom"), for: .normal)
        } else {
            explosionsSwitchButton.setBackgroundImage(UIImage(systemName: "burn"), for: .normal)
        }
        explosionsSwitchButton.tintColor = .CBTheme.secondary ?? .systemGreen
        explosionsSwitchButton.addTapGestureRecognizer {
            vc.explosionsOn.toggle()
        }
        explosionsSwitchButton.constrainToEdgePosition(.topRight, in: vc.view, safeArea: true)
        vc.explosionsOnSwitchButton = explosionsSwitchButton
    }
    
    static func configure3DGraphicButton(for vc: CBBaseViewController, size: CGFloat = CBConstants.UI.defaultButtonSize){
        let graphicPresenterButton = CBButton()
        guard let delegate = vc as? GraphicPresenter else { return }
        graphicPresenterButton.heightConstant(size)
        graphicPresenterButton.widthConstant(size)
        graphicPresenterButton.setBackgroundImage(UIImage(systemName: "rotate.3d"), for: .normal)
        graphicPresenterButton.tintColor = .CBTheme.secondary ?? .systemGreen
        graphicPresenterButton.addTapGestureRecognizer {
            delegate.show3DGraphic()
        }
        graphicPresenterButton.constrainToEdgePosition(.bottomRight, in: vc.view, safeArea: true)
        vc.present3DButton = graphicPresenterButton
    }
    
    static func configureThemeChangeButton(for vc: CBBaseViewController, size: CGFloat = CBConstants.UI.defaultButtonSize) {
        let themeSwitchButton = CBButton()
        themeSwitchButton.heightConstant(size)
        themeSwitchButton.widthConstant(size)
        themeSwitchButton.setBackgroundImage(UIImage(systemName: "lightbulb.circle"), for: .normal)
        themeSwitchButton.tintColor = .CBTheme.secondary ?? .systemGreen
        themeSwitchButton.addTapGestureRecognizer {
            self.themeChanged(vc: vc)
        }
        themeSwitchButton.constrainToEdgePosition(.topLeft, in: vc.view, safeArea: true)
    }
    
    static func themeChanged(vc: CBBaseViewController) {
        var theme: UIUserInterfaceStyle = .dark
        switch vc.view.window?.traitCollection.userInterfaceStyle {
        case .light:
            break
        case .dark:
            theme = .light
        default:
            break
        }
        UIView.animate(withDuration: 0.50, delay: 0.05, options: .curveEaseOut) {
            vc.view.window?.overrideUserInterfaceStyle = theme
        }
    }
}
