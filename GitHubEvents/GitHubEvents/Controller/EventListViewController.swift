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
        contentView.tableView.delegate = self
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

extension EventListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell else { return }

        guard let image = cell.authorImage.image else { return }
        print(image)
//        let eventDetailsViewController = EventDetailsViewController(event: dataSource.events[indexPath.row], authorImage: image)
        
        let eventDetailsViewController = EventDetailsViewController()
        eventDetailsViewController.image = image
        eventDetailsViewController.event = dataSource.events[indexPath.row]
        
        self.navigationController?.pushViewController(eventDetailsViewController, animated: true)
        
//      self.present(eventDetailsViewController, animated: true, completion: nil)

    }
}
