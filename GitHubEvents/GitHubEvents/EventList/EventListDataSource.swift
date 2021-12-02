//
//  EventListDataSource.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//
import UIKit
import CoreData

class EventListDataSource: NSObject, UITableViewDataSource {
    
    static let menuTitles = ["PUSH", "CREATE", "DELETE"]
    static let shared = EventListDataSource()
    
    var selectedEvents = [Event]()
    var selectedIndex = 0
    
    var events: [Event] = []
    let pageMAX = 10
    var page = 1
    
    func loadMore(_ tableView: UITableView) {
        page += 1
        NetworkClient.getEvents(page: page, tableView: tableView) { [weak self] events in
            guard let self = self else { return }
            self.events.append(contentsOf: events)
            self.filterEvents()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedEvents.count
    }
    
    func filterEvents() {
        selectedEvents = events.filter({
            $0.type!.contains(EventType.getEventType(selectedIndex: selectedIndex))
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? EventListTableViewCell else {
            return UITableViewCell()
        }
        let event = self.selectedEvents[indexPath.row]
        let state = CellState(authorImageData: event.avatarImage, date: event.date ?? "", type: event.type ?? "", authorName: event.author?.authorName ?? "")
        cell.update(state: state)
        
        /// Check if the last row number is the same as the last current data element
        if indexPath.row == self.selectedEvents.count - 1 && page <= pageMAX {
            self.loadMore(tableView)
        }
        return cell
    }
}
