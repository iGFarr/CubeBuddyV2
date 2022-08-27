//
//  SolveCellModel.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/26/22.
//

import UIKit

class SolveCellModel: UITableViewCell {

    let solveTimeLabel = UILabel()
    let scrambleLabel = UILabel()
    let puzzleLabel = UILabel()
    let stackView = UIStackView()
    let customSeparator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        // Set any attributes of your UI components here.
        setup()
        CBViewCreator.createCellSeparator(for: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.solveTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.solveTimeLabel.font = UIFont.CBFonts.primary
        self.solveTimeLabel.textColor = UIColor.CBTheme.secondary
        self.solveTimeLabel.numberOfLines = 1
        
        self.scrambleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.scrambleLabel.font = UIFont.CBFonts.primary
        self.scrambleLabel.textColor = UIColor.CBTheme.secondary
        self.scrambleLabel.numberOfLines = 0
        
        self.puzzleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.puzzleLabel.font = UIFont.CBFonts.primary
        self.puzzleLabel.textColor = UIColor.CBTheme.secondary
        self.puzzleLabel.numberOfLines = 1
        
        self.stackView.alignment = .leading
        self.stackView.distribution = .fill
        self.stackView.axis = .vertical
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.spacing = CBConstants.UIConstants.defaultStackViewSpacing
        
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
