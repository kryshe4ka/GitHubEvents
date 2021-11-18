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
    var context: NSManagedObjectContext?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<CoreDataEvent> = {
      let fetchRequest: NSFetchRequest<CoreDataEvent> = CoreDataEvent.fetchRequest()
//      fetchRequest.fetchLimit = 20
      
      let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
      fetchRequest.sortDescriptors = [sortDescriptor]
      
      let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context!, sectionNameKeyPath: nil, cacheName: nil)
      frc.delegate = self
      return frc
    }()
    
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
        
//        do {
//          try fetchedResultsController.performFetch()
//            self.eventListContentView.tableView.reloadData()
//        } catch {
//          fatalError("Core Data fetch error")
//        }

        NetworkClient.getEvents(page: page, tableView: self.eventListContentView.tableView) { [weak self] events in
            guard let self = self else { return }
            self.dataSource.events = events
            
            self.saveEventsInCoreData(events: events)
        }
    }
    
    func saveEventsInCoreData(events: [Event]) {
        guard let context = self.context else { return }
        for event in events {
            let newEvent = CoreDataEvent(context: context)
            newEvent.type = event.type
            newEvent.date = event.date
            newEvent.avatarUrl = event.author?.avatarUrl
            newEvent.authorName = event.author?.authorName
            newEvent.repo = event.repo.name
        }
        do {
          try context.save()
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
