//
//  CBStepper.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 12/4/22.
//

import UIKit

final class CBStepper: UIStepper {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
