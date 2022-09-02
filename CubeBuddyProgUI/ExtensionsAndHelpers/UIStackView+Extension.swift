//
//  UIStackView+Extension.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 9/2/22.
//

import UIKit

extension UIStackView {
    public func addArrangedSubviews(_ arrangedSubviews: [UIView]) {
        for subview in arrangedSubviews {
            addArrangedSubview(subview)
        }
    }
}
