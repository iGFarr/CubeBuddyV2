//
//  Solve+CoreDataProperties.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 9/6/22.
//
//

import Foundation
import CoreData


extension Solve: RetrievableCDObject {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "Solve")
    }

    @NSManaged public var scramble: String
    @NSManaged public var time: String
    @NSManaged public var puzzle: String
    @NSManaged public var date: String
}

extension Solve : Identifiable {

}

protocol RetrievableCDObject {
    static func createFetchRequest() -> NSFetchRequest<NSFetchRequestResult>
}
