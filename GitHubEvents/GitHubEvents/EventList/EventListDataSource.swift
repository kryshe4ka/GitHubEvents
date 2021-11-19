//
//  EventListDataSource.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//
import UIKit
import CoreData

class EventListDataSource: NSObject, UITableViewDataSource {
    
    var events: [Event] = []
    let pageMAX = 10
    var page = 1
    var coreDataEvents: [EventEntity] = []
//    var fetchedResultsController: NSFetchedResultsController<EventEntity>?
    var storageContext: CoreDataStorageContext?


//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return events.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? EventListTableViewCell else {
//            return UITableViewCell()
//        }
//        cell.event = self.events[indexPath.row]
//
//        // Check if the last row number is the same as the last current data element
//        if indexPath.row == self.events.count - 1 && page <= pageMAX {
//            self.loadMore(tableView)
//        }
//        return cell
//    }
    
    func loadMore(_ tableView: UITableView) {
        page += 1
        NetworkClient.getEvents(page: page, tableView: tableView) { [weak self] events in
            guard let self = self else { return }
            self.events.append(contentsOf: events)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let fetchedResultsController = self.storageContext?.fetchedResultsController else { return  0}
        return fetchedResultsController.sections?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedResultsController = self.storageContext?.fetchedResultsController else { return 0 }
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? EventListTableViewCell else {
            return UITableViewCell()
        }
        
        if let fetchedResultsController = self.storageContext?.fetchedResultsController {
            let eventCR = fetchedResultsController.object(at: indexPath)
            let event = Event(author: Event.Actor(authorName: eventCR.authorName, avatarUrl: eventCR.avatarUrl), repo: Event.Repo(name: eventCR.repo), type: eventCR.type, date: eventCR.date, avatarImage: eventCR.avatarImage)
            cell.event = event
        } else {
            cell.event = self.events[indexPath.row]
        }
        
        // Check if the last row number is the same as the last current data element
        if indexPath.row == self.events.count - 1 && page <= pageMAX {
            self.loadMore(tableView)
        }
        return cell
    }
    
}
