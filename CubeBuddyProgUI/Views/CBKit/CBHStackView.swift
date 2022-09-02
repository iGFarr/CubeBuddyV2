//
//  CBHStackView.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 9/1/22.
//

import UIKit

final class CBHStackView: CBStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .equalSpacing
        axis = .horizontal
        spacing = CBConstants.UI.defaultStackViewSpacing
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

