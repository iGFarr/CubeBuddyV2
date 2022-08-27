//
//  ScrambledCubeGraphicVC.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/26/22.
//

import UIKit

class ScrambledCubeGraphicVC: CBBaseViewController {
    var scramble = ""
    var cube = Cube()
    var rootVC: CBBaseViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateCubeGraphic(with: cube)
    }
    
    func updateCubeGraphic(with cube: Cube){
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        CBViewCreator.createCubeGraphicView(for: self, with: cube)
    }
}
