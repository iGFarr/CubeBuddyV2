//
//  SolveSession+CoreDataProperties.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 12/6/22.
//

import Foundation
import CoreData


extension SolveSession: RetrievableCDObject {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "SolveSession")
    }
    @NSManaged public var solves: NSOrderedSet
    @NSManaged public var sessionId: Int
}

extension SolveSession : Identifiable {

}
