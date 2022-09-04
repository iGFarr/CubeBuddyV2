//
//  CBAVHelper.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 9/3/22.
//

import AVFoundation
final class CBAVHelper {
    var player = AVAudioPlayer()
    func playVictorySound(){
        let url = Bundle.main.url(forResource: "FFFanfare", withExtension: "m4a")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
}
