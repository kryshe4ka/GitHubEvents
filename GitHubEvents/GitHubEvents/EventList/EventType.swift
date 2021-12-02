//
//  EventType.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 2.12.21.
//

enum EventType: String {
    case push = "PushEvent"
    case create = "CreateEvent"
    case delete = "DeleteEvent"
    
    static func getEventType(selectedIndex: Int) -> String {
        switch selectedIndex {
        case 0:
            return EventType.push.rawValue
        case 1:
            return EventType.create.rawValue
        case 2:
            return EventType.delete.rawValue
        default:
            return EventType.push.rawValue
        }
    }
}
