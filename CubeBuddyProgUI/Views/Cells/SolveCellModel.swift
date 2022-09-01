//
//  SolveCellModel.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/26/22.
//

import UIKit

class SolveCellModel: UITableViewCell {

    let solveTimeLabel = CBLabel()
    let scrambleLabel = CBLabel()
    let puzzleLabel = CBLabel()
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
        solveTimeLabel.numberOfLines = 1
        puzzleLabel.numberOfLines = 1
        
        CBConstraintHelper.constrain(stackView, to: contentView, usingInsets: true)
        contentView.addSubview(puzzleLabel)
        stackView.addArrangedSubview(solveTimeLabel)
        stackView.addArrangedSubview(scrambleLabel)
        NSLayoutConstraint.activate([
            puzzleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CBConstants.UI.doubleInset),
            puzzleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CBConstants.UI.defaultInsets),
            scrambleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
}
