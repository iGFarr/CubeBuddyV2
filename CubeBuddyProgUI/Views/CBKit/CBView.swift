//
//  CBView.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/29/22.
//

import UIKit

class CBView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
