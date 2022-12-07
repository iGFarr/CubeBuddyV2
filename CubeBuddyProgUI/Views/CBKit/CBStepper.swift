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
        setUp()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderColor = UIColor.CBTheme.secondary?.resolvedColor(with: UITraitCollection.current).cgColor
        layer.borderWidth = 2
        layer.cornerRadius = CBConstants.UI.buttonCornerRadius
        setDecrementImage(self.decrementImage(for: .normal), for: .normal)
        setIncrementImage(self.incrementImage(for: .normal), for: .normal)
        tintColor = .CBTheme.secondary
    }
}
