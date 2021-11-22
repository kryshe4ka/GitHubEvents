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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventListContentView.tableView.dataSource = dataSource
        eventListContentView.tableView.delegate = self
        setUpNavigation()
        getEventsFromStorage()
        getNetworkEvents()
    }
    
    func setUpNavigation() {
        self.navigationItem.title = "Table of events"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    }
    
    func getEventsFromStorage() {
        CoreDataClient.fetchEvents { result in
            switch result {
            case .success(let events):
                self.dataSource.events = events
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getNetworkEvents() {
        NetworkClient.getEvents(page: page, tableView: self.eventListContentView.tableView) { [weak self] events in
            guard let self = self else { return }
            self.dataSource.events = events
        }
    }
}

// MARK: - UITableViewDelegate
extension EventListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = dataSource.events[indexPath.row]
        let eventDetails = EventDetailsState(authorImageData: event.avatarImage, repo: event.repo.name ?? "", authorName: event.author?.authorName ?? "")
        let eventDetailsViewController = EventDetailsViewController(eventDetails: eventDetails)
        self.navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
}
