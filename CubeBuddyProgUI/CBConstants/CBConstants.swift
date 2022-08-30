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
    
    struct UIConstants {
        static let buttonCornerRadius: CGFloat = 10
        static let cellSeparatorHeight: CGFloat = 2
        static let cubeFaceDimension: CGFloat = 90
        static let cubeTileDimension: CGFloat = 25
        static let cubeButtonWidth:CGFloat = 35
        static let defaultInsets: CGFloat = 8
        static let defaultInsetX4: CGFloat = 32
        static let defaultPickerViewHeight: CGFloat = 250
        static let defaultStackViewSpacing: CGFloat = 16
        static let doubleInset: CGFloat = 16
        static let stackViewTrailingInset: CGFloat = 24
        static func makeTextAttributedWithCBStyle(text: String, size: CBBasicFontSize = .medium, color: UIColor = .CBTheme.secondary ?? .systemGreen, textStyle: UIFont.TextStyle = .subheadline) -> NSAttributedString {
            let font: UIFont = .CBFonts.returnCustomFont(size: size, textStyle: textStyle)
            let textAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: color, .font: font]
            return NSAttributedString(string: text, attributes: textAttributes)
        }
    }
    
    static let menuPageTitle = "Menu"
}
