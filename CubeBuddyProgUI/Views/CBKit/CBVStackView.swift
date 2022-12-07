//
//  CBVStackView.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/29/22.
//

import UIKit

final class CBVStackView: CBStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        alignment = .leading
        distribution = .fill
        axis = .vertical
        spacing = CBConstants.UI.defaultStackViewSpacing
    }
}
