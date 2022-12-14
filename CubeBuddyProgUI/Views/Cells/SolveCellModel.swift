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
    let spacerLabel = CBLabel()
    let stackView = CBVStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        puzzleLabel.constrainToEdgePosition(.topRight, in: contentView)
        dateLabel.constrainToEdgePosition(.bottomRight, in: contentView)
        spacerLabel.text = " " // Something interesting I learned from this, even a single white space grants the label
                               // some intrinsic height. Without the space, this fails to provide the desired constraints.
        stackView.addArrangedSubviews([
            solveTimeLabel,
            scrambleLabel,
            spacerLabel // Will replace this eventually. Just using this to make additional space to keep date label exposed.
        ])
        CBConstraintHelper.constrain(stackView, to: contentView, usingInsets: true)
        CBTableViewCellCreator.createCellSeparator(for: self)
    }
}
