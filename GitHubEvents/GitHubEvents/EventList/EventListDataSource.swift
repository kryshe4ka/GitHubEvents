//
//  EventListDataSource.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//
import UIKit
import CoreData

class EventListDataSource: NSObject, UITableViewDataSource {
    
    static let menuTitles = ["Push", "Create", "Delete"]
    
    var events: [Event] = []
    let pageMAX = 10
    var page = 1

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? EventListTableViewCell else {
            return UITableViewCell()
        }
        let event = self.events[indexPath.row]
        let state = CellState(authorImageData: event.avatarImage, date: event.date ?? "", type: event.type ?? "", authorName: event.author?.authorName ?? "")
        cell.update(state: state)
        
        // Check if the last row number is the same as the last current data element
        if indexPath.row == self.events.count - 1 && page <= pageMAX {
            self.loadMore(tableView)
        }
        return cell
    }
    
    func loadMore(_ tableView: UITableView) {
        page += 1
        NetworkClient.getEvents(page: page, tableView: tableView) { [weak self] events in
            guard let self = self else { return }
            self.events.append(contentsOf: events)
        }
    }
}
