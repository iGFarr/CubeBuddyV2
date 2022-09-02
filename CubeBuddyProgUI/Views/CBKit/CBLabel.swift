//
//  CBLabel.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/29/22.
//

import UIKit

final class CBLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.CBFonts.primary
        textColor = UIColor.CBTheme.secondary
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
