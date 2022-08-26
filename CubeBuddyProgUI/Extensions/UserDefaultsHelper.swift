//
//  UserDefaults+Extension.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 8/26/22.
//

import Foundation

class UserDefaultsHelper {
    static func getAllObjects<T: Codable>(named name: String) -> [T] {
          if let objects = UserDefaults.standard.value(forKey: name) as? Data {
             let decoder = JSONDecoder()
             if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [T] {
                return objectsDecoded
             } else {
                return [T]()
             }
          } else {
             return [T]()
          }
       }

    static func saveAllObjects<T: Codable>(allObjects: [T], named name: String) {
          let encoder = JSONEncoder()
          if let encoded = try? encoder.encode(allObjects){
             UserDefaults.standard.set(encoded, forKey: name)
          }
     }
}
