//
//  Event.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import Foundation
import UIKit

public struct Event: Codable {
    struct Actor: Codable {
        let authorName: String?
        let avatarUrl: String?
        enum CodingKeys: String, CodingKey {
            case authorName = "display_login"
            case avatarUrl = "avatar_url"
        }
    }
    let author: Actor?
    struct Repo: Codable {
        let name: String?
    }
    let repo: Repo
    let type: String?
    let date: String?
    var avatarImage: Data?

    enum CodingKeys: String, CodingKey {
        case author = "actor"
        case repo
        case type
        case date = "created_at"
        case avatarImage
    }
}
