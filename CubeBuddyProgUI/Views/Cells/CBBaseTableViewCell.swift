//
//  CBBaseTableViewCell.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 9/2/22.
//

import UIKit

class CBBaseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.font = UIFont.CBFonts.primary
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
