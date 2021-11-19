//
//  Event+CoreDataClass.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 18.11.21.
//

import Foundation
import CoreData

//extension NSManagedObject: Storable {
//    
//}

@objc(EventEntity)
public class EventEntity: NSManagedObject {

}

extension EventEntity: Storable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventEntity> {
        return NSFetchRequest<EventEntity>(entityName: "EventEntity")
    }
    @NSManaged public var type: String?
    @NSManaged public var repo: String?
    @NSManaged public var date: String?
    @NSManaged public var avatarUrl: String?
    @NSManaged public var authorName: String?
    @NSManaged public var avatarImage: Data?
}

