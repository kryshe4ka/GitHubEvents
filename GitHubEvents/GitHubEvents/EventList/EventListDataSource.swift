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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? EventListTableViewCell else {
            return UITableViewCell()
        }
        cell.event = self.events[indexPath.row]
        
        // Check if the last row number is the same as the last current data element
        if indexPath.row == self.events.count - 1 {
            self.loadMore()
        }
        return cell
    }
    
    func loadMore() {
        print("loadMore")
    }
}
