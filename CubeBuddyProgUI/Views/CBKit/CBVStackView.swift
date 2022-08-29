//
//  CBVStackView.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/29/22.
//

import UIKit

class CBVStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        alignment = .leading
        distribution = .fill
        axis = .vertical
        translatesAutoresizingMaskIntoConstraints = false
        spacing = CBConstants.UIConstants.defaultStackViewSpacing
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
