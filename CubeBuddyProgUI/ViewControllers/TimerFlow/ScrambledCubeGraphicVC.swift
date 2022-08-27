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
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        let scrambleArray = scramble.dropFirst("Scramble\n\n".count).split(separator: " ")
        cube = cube.makeMoves(cube.convertStringToMoveList(scramble: scrambleArray.map({ move in
            String(move)
        })))
        updateCubeGraphic(with: cube)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    func updateCubeGraphic(with cube: Cube){
        CBViewCreator.createCubeGraphicView(for: self, with: cube)
    }
}
