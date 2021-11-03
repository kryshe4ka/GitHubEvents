//
//  ViewController.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import UIKit

class EventListViewController: UIViewController {

    var contentView = ContentView()
    var dataSource = EventListDataSource()
    var networkManager = NetworkManager()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.tableView.dataSource = dataSource
        
        // add title for navigation bar
        self.navigationItem.title = "Table of events"
        
//        dataSource.fetchEvents()
        
        networkManager.fetchEvents(page: 1) { events, error in
            if let events = events {
                /// Update event items on main thread
                DispatchQueue.main.async {
                    self.dataSource.events = events
                    self.contentView.tableView.reloadData()
                }
            }
        }
    }

}