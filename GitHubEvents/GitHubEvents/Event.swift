//
//  Event.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import Foundation

struct Event: Codable {
    let id: String?
    let type: String?
    struct Actor: Codable {
        let display_login: String?
        let avatar_url: String?
    }
    let actor: Actor?
    struct Repo: Codable {
        let name: String?
    }
    let repo: Repo
    let created_at: String
}
