//
//  UIFonts+Extension.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/3/22.
//

import UIKit

extension UIFont {
    struct CBFonts {
        static func returnCustomFont(size: CGFloat = 24) -> UIFont {
            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline)
                .withDesign(.monospaced)
            return UIFont(descriptor: descriptor ?? .preferredFontDescriptor(withTextStyle: .subheadline), size: size)
        }
        
        static let primary: UIFont = returnCustomFont()
    }
}
