//
//  String+Extension.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 9/5/22.
//

import Foundation

extension String {
    public func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
