//
//  Event.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import Foundation

struct Event: Codable {
    let id: String
    let type: String
    struct Actor: Codable {
        let id: Int
        let login: String
        let display_login: String
        let gravatar_id: String
        let url: String
        let avatar_url: String
    }
    let actor: Actor
    struct Repo: Codable {
        let id: Int
        let name: String
        let url: String
    }
    let repo: Repo
    struct Payload: Codable {
        let action: String
    }
    let `public`: Bool
    let created_at: String
    struct Org: Codable {
        let id: Int
        let login: String
        let gravatar_id: String
        let url: String
        let avatar_url: String
    }
    let org: Org
}
