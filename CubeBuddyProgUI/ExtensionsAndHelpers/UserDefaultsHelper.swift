//
//  UserDefaults+Extension.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/26/22.
//

import Foundation

struct UserDefaultsHelper {
    struct DefaultKeys {
        enum Floats: String {
            case scrambleLength = "scramble length"
        }
        enum Bools: String {
            case soundsOn = "sounds on"
            case explosionsOn = "explosions on"
        }
        enum Doubles: String {
            case customAvgX = "xValue"
        }
        enum Ints: String {
            case firstLoad = "first load"
            case selectedSession = "selectedSession"
        }
    }
    
    // Retrieval
    static func getFloatForKeyIfPresent(key: UserDefaultsHelper.DefaultKeys.Floats) -> Float {
        return UserDefaults.standard.float(forKey: key.rawValue)
    }
    static func getBoolForKeyIfPresent(key: UserDefaultsHelper.DefaultKeys.Bools) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    static func getDoubleForKeyIfPresent(key: UserDefaultsHelper.DefaultKeys.Doubles) -> Double {
        return UserDefaults.standard.double(forKey: key.rawValue)
    }
    static func getIntForKeyIfPresent(key: UserDefaultsHelper.DefaultKeys.Ints) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    // Setting
    static func setFloatFor(key: UserDefaultsHelper.DefaultKeys.Floats, value: Float) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    static func setBoolFor(key: UserDefaultsHelper.DefaultKeys.Bools, value: Bool) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    static func setDoubleFor(key: UserDefaultsHelper.DefaultKeys.Doubles, value: Double) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    static func setIntFor(key: UserDefaultsHelper.DefaultKeys.Ints, value: Int) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
//    UserDefaults.standard.setValue(scrambleLengthSlider.value, forKey: UserDefaultsHelper.DefaultKeys.Floats.scrambleLength.rawValue)
    
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
