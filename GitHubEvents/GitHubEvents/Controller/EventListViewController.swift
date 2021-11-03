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
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.tableView.dataSource = dataSource
        setUpNavigation()
                
        NetworkManager.fetchEvents(page: 1) { events, error in
            if let events = events {
                /// Update event items on main thread
                DispatchQueue.main.async {
                    self.dataSource.events = events
                    self.contentView.tableView.reloadData()
                }
            }
        }
    }
    
    func setUpNavigation() {
        self.navigationItem.title = "Table of events"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    }

}
