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
            picker.heightAnchor.constraint(equalToConstant: CBConstants.UIConstants.defaultPickerViewHeight),
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
        let color: UIColor = .CBTheme.secondary ?? .systemRed
        let customFont: UIFont = .CBFonts.primary
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color, .font: customFont]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
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
}
