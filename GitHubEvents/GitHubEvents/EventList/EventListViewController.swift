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
    
    var storageContext: CoreDataStorageContext!
    
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
        self.dataSource.storageContext = self.storageContext
        
        do {
            try storageContext.fetch()
//            self.eventListContentView.tableView.reloadData()
        } catch {
          fatalError("Core Data fetch error")
        }

        NetworkClient.getEvents(page: page, tableView: self.eventListContentView.tableView) { [weak self] events in
            guard let self = self else { return }
            self.dataSource.events = events
            self.saveEventsInStorageContext(events: events)
        }
    }
    
    func saveEventsInStorageContext(events: [Event]) {
        var storableObjects: [Storable] = []
        for event in events {
            let newEvent = self.storageContext.create()
            if var newEvent = newEvent {
                newEvent.type = event.type
                newEvent.date = event.date
                newEvent.avatarUrl = event.author?.avatarUrl
                newEvent.authorName = event.author?.authorName
                newEvent.repo = event.repo.name
                newEvent.avatarImage = event.avatarImage
                storableObjects.append(newEvent)
            }
        }
        do {
            try self.storageContext.saveAll(objects: storableObjects)
        } catch {
          fatalError("Core Data Save error")
        }
    }
}

// MARK: - UITableViewDelegate
extension EventListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailsViewController = EventDetailsViewController(event: dataSource.events[indexPath.row])
        self.navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
}
