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
        
        // add title for navigation bar
        self.navigationItem.title = "Table of events"
        
        dataSource.fetchEvents()
        contentView.tableView.reloadData()
    }

}
