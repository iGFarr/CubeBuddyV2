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
        self.backgroundColor = .clear
        setup()
        CBViewCreator.createCellSeparator(for: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.solveTimeLabel.numberOfLines = 1
        self.puzzleLabel.numberOfLines = 1
        
        self.contentView.addSubview(self.stackView)
        self.contentView.addSubview(self.puzzleLabel)
        self.stackView.addArrangedSubview(self.solveTimeLabel)
        self.stackView.addArrangedSubview(self.scrambleLabel)
        
        NSLayoutConstraint.activate([
            self.puzzleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -CBConstants.UIConstants.doubleInset),
            self.puzzleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: CBConstants.UIConstants.defaultInsets),

            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: CBConstants.UIConstants.defaultInsets),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -CBConstants.UIConstants.stackViewTrailingInset),
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: CBConstants.UIConstants.defaultInsets),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -CBConstants.UIConstants.defaultInsets),
            
            self.scrambleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
}
