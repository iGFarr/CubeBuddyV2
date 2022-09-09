//
//  CBConstraintHelper.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 9/1/22.
//

import UIKit

struct CBConstraintHelper {
    static func constrain(_ subView: UIView, to view: UIView, usingInsets: Bool = false, leadingTrailingInset: CGFloat = CBConstants.UI.defaultInsets, topBottomInset: CGFloat = CBConstants.UI.defaultInsets) {
        view.addSubview(subView)
        var horizontalInsets: CGFloat = 0
        var verticalInsets: CGFloat = 0
        if usingInsets {
            horizontalInsets = leadingTrailingInset
            verticalInsets = topBottomInset
        }
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: view.topAnchor, constant: verticalInsets),
            subView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -verticalInsets),
            subView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalInsets),
            subView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalInsets)
        ])
    }
    
    static func constrain(_ subView: UIView, toSafeAreaOf view: UIView, usingInsets: Bool = false, leadingTrailingInset: CGFloat = CBConstants.UI.defaultInsets, topBottomInset: CGFloat = CBConstants.UI.defaultInsets) {
        view.addSubview(subView)
        var horizontalInsets: CGFloat = 0
        var verticalInsets: CGFloat = 0
        if usingInsets {
            horizontalInsets = leadingTrailingInset
            verticalInsets = topBottomInset
        }
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalInsets),
            subView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalInsets),
            subView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalInsets),
            subView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalInsets)
        ])
    }
    
    static func constrainWithCustomInsets(subView: UIView, to view: UIView, leftInset: CGFloat = 0, rightInset: CGFloat = 0, topInset: CGFloat = 0, bottomInset: CGFloat = 0) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subView)
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: view.topAnchor, constant: topInset),
            subView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomInset),
            subView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            subView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -rightInset)
        ])
    }
}

extension CGFloat {
    var scaled: CGFloat {
        self * CBConstants.UI.scaleMultiplier
    }
}
