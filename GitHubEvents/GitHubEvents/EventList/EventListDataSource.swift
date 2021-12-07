//
//  EventListDataSource.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//
import UIKit
import CoreData

class EventListDataSource: NSObject {
    
    static let shared = EventListDataSource()
    let menuTitles = ["PUSH", "CREATE", "DELETE"]
    let accentColor = UIColor.red
    var events: [Event] = []
    var filteredEvents: [[Event]] = []

    func refreshEvents(with events: [Event]) {
        self.events = events
        filterEvents()
    }
    func addMoreEvents(withEvents events: [Event]) {
        self.events.append(contentsOf: events)
        filterEvents()
    }
    func filterEvents() {
        filteredEvents.removeAll()
        for index in 0..<menuTitles.count {
            let selectedEvents = events.filter({
                $0.type!.contains(EventType.getEventType(selectedIndex: index))
            })
            filteredEvents.append(selectedEvents)
        }
    }
}
