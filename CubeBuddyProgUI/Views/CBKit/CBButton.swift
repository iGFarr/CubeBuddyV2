//
//  CBButton.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/30/22.
//

import UIKit

class CBButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
