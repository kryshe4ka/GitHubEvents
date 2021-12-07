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
    
    var selectedEvents = [Event]()
    var selectedIndex = 0
    var page = 1
    let pageMAX = 10
    
    
//    init() {
//        getNetworkEvents()
//    }
    
//    func getNetworkEvents() {
//        NetworkClient.getEvents(page: page, tableView: self.eventListContentView.tableView) { [weak self] events in
//            guard let self = self else { return }
//            self.dataSource.events = events
//            self.eventListContentView.refreshControl.endRefreshing()
//        }
//    }
    
    
    
//    func loadMore(_ tableView: UITableView) {
//        page += 1
//        NetworkClient.getEvents(page: page, tableView: tableView) { [weak self] events in
//            guard let self = self else { return }
//            self.events.append(contentsOf: events)
//            self.filterEvents()
//        }
//    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return selectedEvents.count
//    }
    
//    func filterEvents() {
//        selectedEvents = events.filter({
//            $0.type!.contains(EventType.getEventType(selectedIndex: selectedIndex))
//        })
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventListTableViewCell.reuseIdentifier, for: indexPath) as? EventListTableViewCell else {
//            return UITableViewCell()
//        }
//        let event = self.selectedEvents[indexPath.row]
//        let state = CellState(authorImageData: event.avatarImage, date: event.date ?? "", type: event.type ?? "", authorName: event.author?.authorName ?? "")
//        cell.update(state: state)
//        
//        /// Check if the last row number is the same as the last current data element
//        if indexPath.row == self.selectedEvents.count - 1 && page <= pageMAX {
//            self.loadMore(tableView)
//        }
//        return cell
//    }
}
