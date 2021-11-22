//
//  Database.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 18.11.21.
//

import Foundation

enum StorageError: Error {
    case error
    case saveError
    case deleteError
    case fetchError
}

protocol StorageManager {
    
    static func fetchEvents(completion: @escaping (Result<[Event], StorageError>) -> Void )
    static func saveEvents(_ events: [Event], completion: @escaping (Result<Bool, StorageError>) -> Void)
    static func saveAll(completion: @escaping (Result<Bool, StorageError>) -> Void)
    static func deleteAll(completion: @escaping (Result<Bool, StorageError>) -> Void)
    
}
