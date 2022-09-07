//
//  CBConstants.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/2/22.
//

import Foundation
import UIKit

struct CBConstants {
    enum CBMenuPickerPages: String, CaseIterable {
        case timer = "Stopwatch"
        case solves = "Solves"
        case cubeNoob = "Cube Noob"
    }
    
    struct URLStrings {
        static let channelPage = "https://www.youtube.com/channel/UCAHXaslH4yfGCCV_tleWioQ"
    }
    
    struct UI {
        static let buttonCornerRadius: CGFloat = 10
        static let cellSeparatorHeight: CGFloat = 2
        static let cubeFaceDimension: CGFloat = 90
        static let cubeTileDimension: CGFloat = 30
        static let cubeButtonWidth: CGFloat = 45 * scaleMultiplier
        static let defaultButtonSize: CGFloat = isIpad ? 55 : 45
        static let defaultCornerRadius: CGFloat = 6 * scaleMultiplier
        static let defaultInsets: CGFloat = 8 * scaleMultiplier
        static let defaultInsetX4: CGFloat = 32 * scaleMultiplier
        static let defaultStackViewSpacing: CGFloat = 8 * scaleMultiplier
        static let doubleInset: CGFloat = 16 * scaleMultiplier
        static let halfInset: CGFloat = 4 * scaleMultiplier
        static var isIpad: Bool {
            UIDevice.current.userInterfaceIdiom == .pad
        }
        static var isPortraitMode: Bool {
            (UIDevice.current.orientation == .portrait) || (UIDevice.current.orientation == .portraitUpsideDown)
        }
        static var scaleMultiplier: CGFloat {
            if isIpad {
                return 1.5
            }
            if isSmallScreen {
                return 0.7
            }
            if isVerySmallScreen {
                return 0.5
            }
            return 1.0
        }
        static let pickerRowHeight: CGFloat = 50 * scaleMultiplier
        static let pickerComponentWidth: CGFloat = 200 * scaleMultiplier
        static var isSmallScreen: Bool {
            UIScreen.main.bounds.width < 400 && UIScreen.main.bounds.height < 700
        }
        static var isVerySmallScreen: Bool {
            UIScreen.main.bounds.width < 350 && UIScreen.main.bounds.height < 600
        }
        static func makeTextAttributedWithCBStyle(text: String, size: CBBasicFontSize = .medium, color: UIColor = .CBTheme.secondary ?? .systemGreen, textStyle: UIFont.TextStyle = .subheadline, strokeWidth: Int = 0) -> NSAttributedString {
            let font: UIFont = .CBFonts.returnCustomFont(size: size, textStyle: textStyle)
            let textAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: color, .font: font, .strokeWidth: strokeWidth]
            return NSAttributedString(string: text, attributes: textAttributes)
        }
    }
    
    static let defaultPuzzleSize: CGFloat = 3
    static let defaultPuzzleDescription = "3x3"
    static let defaultScrambleLength = 20
    static let defaultScrambleSliderValue: Float = 20.0
    static let menuPageTitle = "Menu".localized()
}
