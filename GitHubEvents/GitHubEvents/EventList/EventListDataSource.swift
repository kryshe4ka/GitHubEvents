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
        fetchEvents(page: page) { [weak self] result in
            switch result {
            case .success(let events):
                if let self = self {
                    self.events.append(contentsOf: events)
                    self.fetchAvatars(tableView)
                }
            case .failure(let error):
                print("Error - \(error)")
            }
        }
    }
    
    func fetchEvents(page: Int, completion: @escaping (Result<[Event], Error>) -> Void) {
        NetworkClient.request(EventsRouter.events(page)).responseDecodable(of: [Event].self) { response in
            switch response.result {
            case .success(let events):
                completion(.success(events))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchAvatars(_ tableView: UITableView) {
        for i in 0..<self.events.count {
            guard let imageUrl = self.events[i].author?.avatarUrl else {
                return
            }
            NetworkClient.download(imageUrl).responseData { response in
                switch response.result {
                case .failure(let error):
                    print("Error while fetching the image: \(error)")
                case .success(let imageData):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.events[i].avatarImage = imageData
                        tableView.reloadData()
                    }
                }
            }
        }
    }
}
