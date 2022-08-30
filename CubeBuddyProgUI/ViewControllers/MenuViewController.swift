//
//  MenuViewController.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/2/22.
//

import UIKit

class MenuViewController: CBBaseViewController {
    private let picker = UIPickerView()
    private let emptyRow = 1
    private let emptyRowIndex = 0
    lazy var viewControllerTitles =
    [
        "Stopwatch": TimerViewController(),
        "Solves": SolvesViewController(),
        "Cube Noob": CubeNoobYoutubePlayerVC()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = CBConstants.menuPageTitle
        createPickerWheel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        picker.selectRow(emptyRowIndex, inComponent: emptyRowIndex, animated: true)
    }
    
    func createPickerWheel(){
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .clear
        picker.isOpaque = false
        
        view.addSubview(picker)
        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            picker.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -CBConstants.UIConstants.defaultInsetX4)
        ])
    }
}

extension MenuViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CBConstants.CBMenuPickerPages.allCases.count + emptyRow
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if row == emptyRowIndex {
            return NSAttributedString(string: "")
        }
        let title = CBConstants.CBMenuPickerPages.allCases[row - 1].rawValue
        let attributedTitle = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: title, size: .large, textStyle: .headline)
        return attributedTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row != emptyRowIndex else { return }
        let title = CBConstants.CBMenuPickerPages.allCases[row - 1].rawValue
        
        if let vc = viewControllerTitles[title] {
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    //FIXME: This block is correctly attributing the row labels, but shifting to the left when scrolling
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let pickerLabel = CBLabel() //get picker label that come
//        var title = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: "", size: .large, textStyle: .headline)
//        if row != emptyRowIndex {
//            title = CBConstants.UIConstants.makeTextAttributedWithCBStyle(text: CBConstants.CBMenuPickerPages.allCases[row - 1].rawValue, size: .large)
//        }
//        pickerLabel.textAlignment = .center
//        pickerLabel.attributedText = title //setting attributed text as title
//        return pickerLabel //return value
//    }
//
}
