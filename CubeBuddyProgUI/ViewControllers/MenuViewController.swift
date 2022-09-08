//
//  MenuViewController.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/2/22.
//

import UIKit

class MenuViewController: CBBaseViewController {
    private let picker = CBPickerView()
    private let emptyRow = 1
    private let emptyRowIndex = 0
    private lazy var viewControllerTitles =
    [
        CBConstants.CBMenuPickerPages.timer.rawValue: TimerViewController(),
        CBConstants.CBMenuPickerPages.solves.rawValue: SolvesViewController(),
        CBConstants.CBMenuPickerPages.cubeNoob.rawValue: CubeNoobYoutubePlayerVC()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = CBConstants.menuPageTitle
        createPickerWheel()
        CBButtonCreator.configureThemeChangeButton(for: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        picker.selectRow(emptyRowIndex, inComponent: emptyRowIndex, animated: false)
    }
    
    private func createPickerWheel(){
        picker.delegate = self
        picker.dataSource = self
        CBConstraintHelper.constrain(picker, to: view)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        viewControllerTitles = [
            CBConstants.CBMenuPickerPages.timer.rawValue: TimerViewController(),
            CBConstants.CBMenuPickerPages.solves.rawValue: SolvesViewController(),
            CBConstants.CBMenuPickerPages.cubeNoob.rawValue: CubeNoobYoutubePlayerVC()
        ]
    }
}

extension MenuViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CBConstants.CBMenuPickerPages.allCases.count + emptyRow
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row != emptyRowIndex else { return }
        let title = CBConstants.CBMenuPickerPages.allCases[row - emptyRow].rawValue
        
        if let vc = viewControllerTitles[title] {
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CBConstants.UI.pickerRowHeight
    }

    /// row title attribution
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = CBLabel() //get picker label that come
        var title = CBConstants.UI.makeTextAttributedWithCBStyle(text: "", size: .large, textStyle: .headline)
        if row != emptyRowIndex {
            title = CBConstants.UI.makeTextAttributedWithCBStyle(text: CBConstants.CBMenuPickerPages.allCases[row - 1].rawValue.localized(), size: .large)
        }
        pickerLabel.textAlignment = .left
        pickerLabel.attributedText = title //setting attributed text as title
        return pickerLabel //return value
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return CBConstants.UI.pickerComponentWidth
    }
}
