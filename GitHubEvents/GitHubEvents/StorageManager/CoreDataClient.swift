//
//  CoreDataManager.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 19.11.21.
//

import Foundation
import CoreData
import UIKit

class CoreDataClient: StorageManager {
    
    static let shared = CoreDataClient()
    var managedContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<EventEntity>?

    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.managedContext = appDelegate.persistentContainer.viewContext
        self.fetchedResultsController = {
            let fetchRequest: NSFetchRequest<EventEntity> = EventEntity.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext!, sectionNameKeyPath: nil, cacheName: nil)
            return frc
        }()
    }
    
    static func fetchEvents(completion: @escaping ([Storable]) -> Void ) throws {
        print("fetchEvents")
        do {
            try shared.fetchedResultsController?.performFetch()
            let fetchedObjects = shared.fetchedResultsController?.fetchedObjects
            completion(shared.convertFromDBEntityToStorable(fetchedObjects: fetchedObjects ?? []))
        } catch {
            fatalError("Core Data fetch error")
        }
    }
    
    private func convertFromDBEntityToStorable(fetchedObjects: [EventEntity]) -> [Storable] {
        var array: [Storable] = []
        for obj in fetchedObjects {
            let event = Event(author: Event.Actor(authorName: obj.authorName, avatarUrl: obj.avatarUrl), repo: Event.Repo(name: obj.repo), type: obj.type, date: obj.date, avatarImage: obj.avatarImage)
            array.append(event)
        }
        return array
    }
    
    static func createEvent(fromEvent: Storable) -> Storable? {
        guard let event = fromEvent as? Event else { return nil }
        guard let context = shared.managedContext else { return nil }

        let newEvent = EventEntity(context: context)
        newEvent.avatarImage = event.avatarImage
        newEvent.repo = event.repo.name
        newEvent.avatarUrl = event.author?.avatarUrl
        newEvent.authorName = event.author?.authorName
        newEvent.avatarImage = event.avatarImage
        newEvent.type = event.type
        newEvent.date = event.date
        return newEvent
    }
    
    static func saveAll() throws {
        print("saveEvents")
        do {
            try shared.managedContext?.save()
        } catch {
            fatalError("CoreData error")
        }
    }
    
    static func deleteAll()
        {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EventEntity")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do
            {
                try shared.managedContext?.execute(deleteRequest)
                try shared.managedContext?.save()
            }
            catch
            {
                print ("There was an error")
            }
        }
}
