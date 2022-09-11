//
//  SolveCellModel.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/26/22.
//

import UIKit

class SolveCellModel: CBBaseTableViewCell {

    let solveTimeLabel = CBLabel()
    let scrambleLabel = CBLabel()
    let puzzleLabel = CBLabel()
    let dateLabel = CBLabel()
    let stackView = CBVStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setup()
        CBTableViewCellCreator.createCellSeparator(for: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        puzzleLabel.constrainToEdgePosition(.topRight, in: contentView)
        stackView.addArrangedSubviews([
            solveTimeLabel,
            dateLabel,
            scrambleLabel
        ])
        CBConstraintHelper.constrain(stackView, to: contentView, usingInsets: true)
    }
}
