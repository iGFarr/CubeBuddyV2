//
//  CBHStackView.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 9/1/22.
//

import UIKit

class CBHStackView: CBStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        axis = .horizontal
        spacing = CBConstants.UI.defaultStackViewSpacing
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

