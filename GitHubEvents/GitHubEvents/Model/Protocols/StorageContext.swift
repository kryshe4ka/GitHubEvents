//
//  Database.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 18.11.21.
//

import Foundation

protocol StorageContext {

    func create() -> Storable?
//    func create<DBEntity: Storable>(_ model: DBEntity.Type) -> DBEntity?
    func save(object: Storable) throws
    func saveAll(objects: [Storable]) throws
    func update(object: Storable) throws
    func delete(object: Storable) throws
    func deleteAll(_ model: Storable.Type) throws
//    func fetch(_ model: Storable.Type, predicate: NSPredicate?, sorted: Sorted?) -> [Storable]
    func fetch() throws
}

public struct Sorted {
    var key: String
    var ascending: Bool = true
}
