//
//  CBPickerView.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 9/2/22.
//

import UIKit

final class CBPickerView: UIPickerView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        isOpaque = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

