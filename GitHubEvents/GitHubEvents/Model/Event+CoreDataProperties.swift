//
//  Event+CoreDataProperties.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 18.11.21.
//

import Foundation
import CoreData
//import UIKit

extension CoreDataEvent {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataEvent> {
        return NSFetchRequest<CoreDataEvent>(entityName: "CoreDataEvent")
    }
  
    @NSManaged public var type: String?
    @NSManaged public var repo: String?
    @NSManaged public var date: String?
    @NSManaged public var avatarUrl: String?
    @NSManaged public var authorName: String?

}
