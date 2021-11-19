//
//  Model.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 18.11.21.
//

import Foundation
import CoreData

protocol Storable {
    
    init()
    
    var type: String? { get set }
    var repo: String? { get set }
    var date: String? { get set }
    var avatarUrl: String? { get set }
    var authorName: String? { get set }
    var avatarImage: Data? { get set }
}
