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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let scrambleArray = scramble.dropFirst("Scramble\n\n".count).split(separator: " ")
        cube = cube.makeMoves(cube.convertStringToMoveList(scramble: scrambleArray.map({ move in
            String(move)
        })))
        updateCubeGraphic(with: cube)
    }
    
    func updateCubeGraphic(with cube: Cube){
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        CBViewCreator.createCubeGraphicView(for: self, with: cube)
    }
}
