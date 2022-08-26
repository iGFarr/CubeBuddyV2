//
//  MenuViewController.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/2/22.
//

import UIKit

class MenuViewController: CBBaseViewController {
    let picker = UIPickerView()
    lazy var stopwatchVC = TimerViewController()
    lazy var solvesVC = SolvesViewController()
    lazy var cubeNoobYoutubePlayerVC = CubeNoobYoutubePlayerVC()
    lazy var viewControllerTitles =
    [
        "Stopwatch": stopwatchVC,
        "Solves": solvesVC,
        "Cube Noob": cubeNoobYoutubePlayerVC
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menu"
        createPickerWheel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        picker.selectRow(0, inComponent: 0, animated: true)
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
            picker.heightAnchor.constraint(equalToConstant: 250),
            picker.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32)
        ])
    }
}

extension MenuViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CBConstants.PickerRows.allCases.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if row == 0 {
            return NSAttributedString(string: "")
        }
        let title = CBConstants.PickerRows.allCases[row - 1].rawValue
        let color: UIColor = .CBTheme.secondary ?? .systemRed
        let customFont: UIFont = .CBFonts.returnCustomFont(size: 20)
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color, .font: customFont]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        return attributedTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row != 0 else { return }
        let title = CBConstants.PickerRows.allCases[row - 1].rawValue
        
        if let vc = self.viewControllerTitles[title] {
            
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
