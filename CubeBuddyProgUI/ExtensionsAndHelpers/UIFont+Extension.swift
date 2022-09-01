//
//  UIFonts+Extension.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/3/22.
//

import UIKit

enum CBBasicFontSize: CGFloat {
    case mini = 8
    case small = 16
    case medium = 24
    case large = 32
    case xl = 40
    case xxl = 48
    case iPad = 56
}
extension UIFont {
    struct CBFonts {
        static func returnCustomFont(size: CBBasicFontSize = .medium, textStyle: UIFont.TextStyle = .subheadline) -> UIFont {
            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline)
                .withDesign(.monospaced)
            return UIFont(descriptor: descriptor ?? .preferredFontDescriptor(withTextStyle: .subheadline), size: size.rawValue)
        }
        
        static let primary: UIFont = returnCustomFont()
    }
}
