//
//  CBConstants.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/2/22.
//

import Foundation
import UIKit

struct CBConstants {
    enum PickerRows: String, CaseIterable {
        case timer = "Stopwatch"
        case solves = "Solves"
        case cubeNoob = "Cube Noob"
    }
    
    struct URLStrings {
        static let channelPage = "https://www.youtube.com/channel/UCAHXaslH4yfGCCV_tleWioQ"
    }
    
    struct UIConstants {
        static let defaultInsets: CGFloat = 8
        static let doubleInset: CGFloat = 16
        static let stackViewTrailingInset: CGFloat = 48
        static let defaultStackViewSpacing: CGFloat = 16
        static let cellSeparatorHeight: CGFloat = 2
    }
}
