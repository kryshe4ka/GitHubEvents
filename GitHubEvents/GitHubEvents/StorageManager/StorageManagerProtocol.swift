//
//  Database.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 18.11.21.
//

import Foundation

protocol StorageManager {
    
    static func fetchEvents(completion: @escaping ([Storable]) -> Void ) throws
    static func createEvent(fromEvent: Storable) -> Storable?
    static func saveAll() throws
    static func deleteAll()
    
}
