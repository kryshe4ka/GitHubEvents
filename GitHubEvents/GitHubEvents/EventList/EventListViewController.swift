//
//  ViewController.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import UIKit

class EventListViewController: UIViewController {

    var eventListContentView = EventListContentView()
    var dataSource = EventListDataSource()
    
    override func loadView() {
        view = eventListContentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventListContentView.tableView.dataSource = dataSource
        eventListContentView.tableView.delegate = self
        setUpNavigation()
        fetchEvents()
    }
    
    func fetchEvents() {
        NetworkManager.fetchEvents(page: 1) { events, error in
            if let events = events {
                self.dataSource.events = events
                self.fetchAvatars()
            }
            if error != nil {
                print(error!)
            }
        }
    }

    func fetchAvatars() {
        for i in 0..<self.dataSource.events.count {
            guard let avatarUrl = self.dataSource.events[i].author?.avatarUrl else {
                return
            }
            NetworkManager.downloadImageData(imageUrl: avatarUrl) { imageData, error in
                guard let imageData = imageData else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.dataSource.events[i].avatarImage = imageData
                    self.eventListContentView.tableView.reloadData()
                }
            }
        }
        return
    }
        
    func setUpNavigation() {
        self.navigationItem.title = "Table of events"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    }
}

extension EventListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailsViewController = EventDetailsViewController(event: dataSource.events[indexPath.row])
        self.navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
}
