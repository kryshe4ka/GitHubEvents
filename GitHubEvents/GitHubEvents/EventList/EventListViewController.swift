//
//  ViewController.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//
import UIKit
import Alamofire
import Foundation
import CoreData

class EventListViewController: UIViewController, NSFetchedResultsControllerDelegate {
        
    var eventListContentView = EventListContentView()
    var dataSource = EventListDataSource()
    var page = 1
    
    override func loadView() {
        view = eventListContentView
    }
    
    func setUpNavigation() {
        self.navigationItem.title = "Table of events"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventListContentView.tableView.dataSource = dataSource
        eventListContentView.tableView.delegate = self
        setUpNavigation()

        getEventsFromStorage()

        NetworkClient.getEvents(page: page, tableView: self.eventListContentView.tableView) { [weak self] events in
            guard let self = self else { return }
            self.dataSource.events = events
            self.saveEventsInStorage(events: events)
        }
    }
    
    func getEventsFromStorage() {
        do {
            try CoreDataClient.fetchEvents { events in
                self.dataSource.events = events
            }
        } catch {
            fatalError("Core Data fetch error")
        }
    }
    
    func saveEventsInStorage(events: [Storable]) {
        for event in events {
            CoreDataClient.createEvent(fromEvent: event)
        }
        do {
            try CoreDataClient.saveAll()
        } catch {
            fatalError("Core Data fetch error")
        }
    }
}

// MARK: - UITableViewDelegate
extension EventListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailsViewController = EventDetailsViewController(event: dataSource.events[indexPath.row] as! Event)
        self.navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
}
