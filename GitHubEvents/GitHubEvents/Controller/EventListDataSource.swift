//
//  EventListDataSource.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import UIKit

class EventListDataSource: NSObject, UITableViewDataSource {
    
    var events: [Event] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.event = self.events[indexPath.row]
//        cell.authorName.text = self.events[indexPath.row].author?.authorName
//        cell.eventType.text = self.events[indexPath.row].type
//        cell.eventDate.text = self.events[indexPath.row].date

        return cell
    }
    
}

extension EventListDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
}
