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

class EventListViewController: UIViewController {
    var eventListContentView = EventListContentView()
    var dataSource = EventListDataSource.shared

    var page = 1
        
    override func loadView() {
        view = eventListContentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
        setUpNavigation()
        setupMenu()
        getEventsFromStorage()
        getNetworkEvents()
    }
    
    func setupMenu() {
        ///for initial state of menu
        eventListContentView.menuCollection.selectItem(at: eventListContentView.selectedIndexPath, animated: false, scrollPosition: .centeredVertically)
    }
    
    func setupContentView() {
        eventListContentView.tableView.dataSource = dataSource
        eventListContentView.tableView.delegate = self
        eventListContentView.refreshControl.addTarget(self, action: #selector(self.refreshEventList(_:)), for: .valueChanged)
        /// set dataSource and delegate for menu collection view
        eventListContentView.menuCollection.dataSource = self
        eventListContentView.menuCollection.delegate = self
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
                self.dataSource.filterEvents()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getNetworkEvents() {
        NetworkClient.getEvents(page: page, tableView: self.eventListContentView.tableView) { [weak self] events in
            guard let self = self else { return }
            self.dataSource.events = events
            self.dataSource.filterEvents()
            self.eventListContentView.refreshControl.endRefreshing()
        }
    }
    
    @objc func refreshEventList(_ sender: AnyObject) {
        getNetworkEvents()
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
