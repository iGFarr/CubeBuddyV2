//
//  Solve+CoreDataProperties.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 9/6/22.
//
//

import Foundation
import CoreData


extension Solve {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Solve> {
        return NSFetchRequest<Solve>(entityName: "Solve")
    }

    @NSManaged public var scramble: String
    @NSManaged public var time: String
    @NSManaged public var puzzle: String

}

extension Solve : Identifiable {

}

