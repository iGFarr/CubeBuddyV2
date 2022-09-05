//
//  CBEnums.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 9/3/22.
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

enum EdgePosition {
    case topRight
    case topLeft
    case bottomRight
    case bottomLeft
    case topCenter
}

enum CubeFace: String {
    case up = "U"
    case down = "D"
    case back = "B"
    case front = "F"
    case left = "L"
    case right = "R"
}

enum CustomColors: String {
    case primary = "CBPrimary"
    case secondary = "CBSecondary"
}

enum SeparatorPosition {
    case top
    case bottom
    case topAndBottom
}
