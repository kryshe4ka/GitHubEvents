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
        guard let context = shared.managedContext else {
            completion(.failure(.error))
            return
        }
        for event in events {
            let newEventEntity = EventEntity(context: context)
            newEventEntity.avatarImage = event.avatarImage
            newEventEntity.repo = event.repo.name
            newEventEntity.avatarUrl = event.author?.avatarUrl
            newEventEntity.authorName = event.author?.authorName
            newEventEntity.avatarImage = event.avatarImage
            newEventEntity.type = event.type
            newEventEntity.date = event.date
        }
        do {
            try shared.managedContext?.save()
            completion(.success(true))
        } catch {
            completion(.failure(.saveError))
        }
    }
    
    static func saveAll(completion: @escaping (Result<Bool, StorageError>) -> Void) {
        do {
            try shared.managedContext?.save()
            completion(.success(true))
        } catch {
            completion(.failure(.saveError))
        }
    }
    
    static func deleteAll(completion: @escaping (Result<Bool, StorageError>) -> Void) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EventEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try shared.managedContext?.execute(deleteRequest)
            try shared.managedContext?.save()
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
