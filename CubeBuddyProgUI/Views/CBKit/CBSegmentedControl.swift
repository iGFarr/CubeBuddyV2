//
//  CBSegmentedControl.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/31/22.
//

import UIKit

class CBSegmentedControl: UISegmentedControl {
    override init(items: [Any]?) {
        super.init(items: items)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
