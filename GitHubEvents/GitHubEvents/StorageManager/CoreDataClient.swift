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
    var fetchedResultsController: NSFetchedResultsController<EventEntity>?
    let modelName = "Events"
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: modelName)
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      })
      return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
      return self.persistentContainer.viewContext
    }()
    
    
    init() {
        self.fetchedResultsController = {
            let fetchRequest: NSFetchRequest<EventEntity> = EventEntity.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
            return frc
        }()
    }
    
    private func convertFromDBEntityToEvents(fetchedObjects: [EventEntity]) -> [Event] {
        var events: [Event] = []
        for object in fetchedObjects {
            let event = Event(author: Event.Actor(authorName: object.authorName, avatarUrl: object.avatarUrl), repo: Event.Repo(name: object.repo), type: object.type, date: object.date, avatarImage: object.avatarImage)
            events.append(event)
        }
        return events
    }
    
    static func fetchEvents(completion: @escaping (Result<[Event], StorageError>) -> Void) {
        do {
            try shared.fetchedResultsController?.performFetch()
            guard let fetchedObjects = shared.fetchedResultsController?.fetchedObjects else { return }
            let events = shared.convertFromDBEntityToEvents(fetchedObjects: fetchedObjects)
            completion(.success(events))
        } catch {
            completion(.failure(.fetchError))
        }
    }
    
    static func saveEvents(_ events: [Event], completion: @escaping (Result<Bool, StorageError>) -> Void) {
        // get main context
        let mainQueueContext = shared.managedContext
        // get private context
        let privateChildContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        // make main context as a parent of child
        privateChildContext.parent = mainQueueContext
        
        privateChildContext.perform {
            for event in events {
                let newEventEntity = EventEntity(context: privateChildContext)
                newEventEntity.avatarImage = event.avatarImage
                newEventEntity.repo = event.repo.name
                newEventEntity.avatarUrl = event.author?.avatarUrl
                newEventEntity.authorName = event.author?.authorName
                newEventEntity.avatarImage = event.avatarImage
                newEventEntity.type = event.type
                newEventEntity.date = event.date
            }
        }
        // merge changes to main context
        privateChildContext.perform {
            do {
                try privateChildContext.save()
            } catch {
                completion(.failure(.saveError))
            }
        }
        
        do {
            try mainQueueContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(.saveError))
        }
    }
    
    static func saveAll(completion: @escaping (Result<Bool, StorageError>) -> Void) {
        do {
            try shared.managedContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(.saveError))
        }
    }
    
    static func deleteAll(completion: @escaping (Result<Bool, StorageError>) -> Void) {
        // get main context
        let mainQueueContext = shared.managedContext
        // get private context
        let privateChildContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        // make main context as a parent of child
        privateChildContext.parent = mainQueueContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EventEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try privateChildContext.execute(deleteRequest)
            // merge changes to main context
            try privateChildContext.save()
            try mainQueueContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(.deleteError))
        }
    }
}

public func deleteEventsFromStorage() {
    CoreDataClient.deleteAll() { result in
        switch result {
        case .failure(let error):
            print(error)
        case .success(_):
            print("Success deleting")
        }
    }
}
public func saveEventsInStorage(events: [Event]) {
    CoreDataClient.saveEvents(events) { result in
        switch result {
        case .failure(let error):
            print(error)
        case .success(_):
            print("Success saving")
        }
    }
}
