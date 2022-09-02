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
    
    enum CornerPosition {
        case topRight
        case topLeft
        case bottomRight
        case bottomLeft
    }
    
    func constrainLabelToCorner(_ corner: CornerPosition, in view: UIView, insetBy inset: CGFloat = CBConstants.UI.doubleInset) {
        view.addSubview(self)
        switch corner {
        case .topLeft:
            top(view.topAnchor, constant: inset)
            leading(view.leadingAnchor, constant: inset)
        case .topRight:
            top(view.topAnchor, constant: inset)
            trailing(view.trailingAnchor, constant: -inset)
        case .bottomLeft:
            bottom(view.bottomAnchor, constant: -inset)
            leading(view.leadingAnchor, constant: inset)
        case .bottomRight:
            bottom(view.bottomAnchor, constant: -inset)
            trailing(view.trailingAnchor, constant: -inset)
        }
    }
}
