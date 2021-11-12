//
//  EventListDataSource.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import UIKit

class EventListDataSource: NSObject, UITableViewDataSource {
    
    var events: [Event] = []
    let pageMAX = 10
    let group = DispatchGroup()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? EventListTableViewCell else {
            return UITableViewCell()
        }
        cell.event = self.events[indexPath.row]
        
        // Check if the last row number is the same as the last current data element
        if indexPath.row == self.events.count - 1 && page <= pageMAX {
            self.loadMore(tableView)
        }
        return cell
    }
    var page = 1
    
    func loadMore(_ tableView: UITableView) {
        page += 1
        group.enter()
        getAllEvents(page: page) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let events):
                self.events.append(contentsOf: events)
                self.fetchAvatars(tableView)
                self.group.leave()
            case .failure(let error):
                print("Error - \(error)")
                self.group.leave()
            }
        }
        group.notify(queue: .main) {
            print("Finished all upload requests.")
            tableView.reloadData()
        }
    }
    
    func fetchAvatars(_ tableView: UITableView) {
        DispatchQueue.concurrentPerform(iterations: self.events.count, execute: { i in
            guard let imageUrl = self.events[i].author?.avatarUrl else {
                return
            }
            self.group.enter()
            NetworkClient.download(imageUrl).responseData { response in
                switch response.result {
                case .failure(let error):
                    print("Error while fetching the image: \(error)")
                case .success(let imageData):
                    self.events[i].avatarImage = imageData
                    self.group.leave()
                }
            }
        })
    }
}
