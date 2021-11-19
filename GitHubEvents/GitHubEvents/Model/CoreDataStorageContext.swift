//
//  CoreDataStorageContext.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 18.11.21.
//

import UIKit
import CoreData

class CoreDataStorageContext {
    var managedContext: NSManagedObjectContext?
    
    lazy var fetchedResultsController: NSFetchedResultsController<EventEntity> = {
        let fetchRequest: NSFetchRequest<EventEntity> = EventEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext!, sectionNameKeyPath: nil, cacheName: nil)
//        frc.delegate = self
        return frc
    }()
    
    required init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.managedContext = appDelegate.persistentContainer.viewContext
    }
}

extension CoreDataStorageContext: StorageContext {
    func create() -> Storable? {
        if let context = self.managedContext {
            return EventEntity(context: context)
        }
        return nil
    }
    
    
//    func create<DBEntity: Storable>(_ model: DBEntity.Type) -> DBEntity? {
//        let entityDescription =  NSEntityDescription.entity(forEntityName: String.init(describing: model.self),
//                                                            in: managedContext!)
//        let entity = NSManagedObject(entity: entityDescription!,
//                                     insertInto: managedContext)
//        return entity as? DBEntity
//    }
    
    
    func save(object: Storable) throws {
        
    }
    
    func saveAll(objects: [Storable]) throws {
        do {
            try self.managedContext?.save()
        } catch {
          fatalError("Core Data Save error")
        }
    }
    
    func update(object: Storable) throws {
        //
    }
    
    func delete(object: Storable) throws {
        //
    }
    
    func deleteAll(_ model: Storable.Type) throws {
        //
    }
    
//    func fetch(_ model: Storable.Type, predicate: NSPredicate?, sorted: Sorted?) -> [Storable] {
//        fetchedResultsController.performFetch()
//        return []
//    }
    
    func fetch() throws {
        do {
            try fetchedResultsController.performFetch()
//            self.dataSource.storageContext?.fetchedResultsController = storageContext.fetchedResultsController
//            self.eventListContentView.tableView.reloadData()
        } catch {
          fatalError("Core Data fetch error")
        }
    }
    
    func objectWithObjectId<DBEntity: Storable>(objectId: NSManagedObjectID) -> DBEntity? {
        do {
            let result = try managedContext!.existingObject(with: objectId)
            return result as? DBEntity
        } catch {
            print("Failure")
        }

        return nil
    }
}
