//
//  CBSegmentedControl.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/31/22.
//

import UIKit

final class CBSegmentedControl: UISegmentedControl {
    override init(items: [Any]?) {
        super.init(items: items)
        setUp()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp(){
        translatesAutoresizingMaskIntoConstraints = false
        let unselectedColor: UIColor = .CBTheme.secondary ?? .systemGreen
        let selectedColor: UIColor = .CBTheme.primary ?? .systemBlue
        selectedSegmentIndex = 0
        selectedSegmentTintColor = .CBTheme.secondary
        setTitleTextAttributes([
            .font: UIFont.CBFonts.returnCustomFont(size: .small),
            .foregroundColor: unselectedColor
        ], for: .normal)
        setTitleTextAttributes([
            .font: UIFont.CBFonts.returnCustomFont(size: .small),
            .foregroundColor: selectedColor
        ], for: .selected)
    }
}
