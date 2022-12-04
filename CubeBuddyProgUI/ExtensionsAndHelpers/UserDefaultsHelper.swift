//
//  UserDefaults+Extension.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/26/22.
//

import Foundation

struct UserDefaultsHelper {
    enum DefaultKeys: String {
        case solves = "solves"
        case scrambleLength = "scramble length"
        case soundsOn = "sounds on"
        case firstLoad = "first load"
        case explosionsOn = "explosions on"
        case customAvgX = "xValue"
    }
//    These aren't being used anymore, but going to keep them around just in case.
//
//    static func getAllObjects<T: Codable>(named name: DefaultKeys) -> [T] {
//        if let objects = UserDefaults.standard.value(forKey: name.rawValue) as? Data {
//             let decoder = JSONDecoder()
//             if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [T] {
//                return objectsDecoded
//             } else {
//                return [T]()
//             }
//          } else {
//             return [T]()
//          }
//       }
//
//    static func saveAllObjects<T: Codable>(allObjects: [T], named name: DefaultKeys) {
//          let encoder = JSONEncoder()
//          if let encoded = try? encoder.encode(allObjects){
//              UserDefaults.standard.set(encoded, forKey: name.rawValue)
//          }
//     }
}
