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
        if indexPath.row == self.events.count - 1 && page <= 10 {
            self.loadMore(tableView)
        }
        return cell
    }
    var page = 1
    
    func loadMore(_ tableView: UITableView) {
        print("loadMore")
        page += 1
        NetworkManager.fetchEvents(page: page) { events, error in
            if let events = events {
                self.events = events
                self.fetchAvatars(tableView)
            }
            if error != nil {
                print(error!)
            }
        }
    }
    
    func fetchAvatars(_ tableView: UITableView) {
        for i in 0..<self.events.count {
            guard let avatarUrl = self.events[i].author?.avatarUrl else {
                return
            }
            NetworkManager.downloadImageData(imageUrl: avatarUrl) { imageData, error in
                guard let imageData = imageData else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.events[i].avatarImage = imageData
                    tableView.reloadData()
                }
            }
        }
        return
    }
}
