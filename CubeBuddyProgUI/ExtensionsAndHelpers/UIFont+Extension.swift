//
//  UIFonts+Extension.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/3/22.
//

import UIKit

extension UIFont {
    struct CBFonts {
        static func returnCustomFont(size: CBBasicFontSize = .medium, textStyle: UIFont.TextStyle = .subheadline) -> UIFont {
            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline)
                .withDesign(.monospaced)
            return UIFont(descriptor: descriptor ?? .preferredFontDescriptor(withTextStyle: .subheadline), size: size.rawValue * CBConstants.UI.scaleMultiplier)
        }
        
        static let primary: UIFont = returnCustomFont()
    }
}
