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
    let delegateAndDataSourceForMenu = DelegateAndDataSourceForMenu()
    let delegateAndDataSourceForContent = DelegateAndDataSourceForContent()
    let eventListContentView = EventListContentView()
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
//        getNetworkEvents()
    }
    
    func setupMenu() {
        ///for initial state of menu
        eventListContentView.menuBar.menuCollection.selectItem(at: eventListContentView.menuBar.selectedIndexPath, animated: false, scrollPosition: .centeredVertically)
    }
    
    func setupContentView() {
        /// set dataSource and delegate for menu collection view
        delegateAndDataSourceForMenu.controller = self
        eventListContentView.menuBar.menuCollection.dataSource = delegateAndDataSourceForMenu
        eventListContentView.menuBar.menuCollection.delegate = delegateAndDataSourceForMenu
        /// set dataSource and delegate for content collection view
        delegateAndDataSourceForContent.controller = self
        eventListContentView.contentView.contentCollection.dataSource = delegateAndDataSourceForContent
        eventListContentView.contentView.contentCollection.delegate = delegateAndDataSourceForContent
    }
    
    func setUpNavigation() {
        self.navigationItem.title = "Table of events"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    }

    func getEventsFromStorage() {
        CoreDataClient.fetchEvents { result in
            switch result {
            case .success(let events):
                EventListDataSource.shared.refreshEvents(with: events)
//                self.eventListContentView.contentView.contentCollection.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    func getNetworkEvents() {
//        NetworkClient.getEvents(page: page, tableView: self.eventListContentView.tableView) { [weak self] events in
//            guard let self = self else { return }
//            self.dataSource.events = events
//            self.eventListContentView.refreshControl.endRefreshing()
//        }
//    }
}

// MARK: - UITableViewDelegate
//extension EventListViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//       return 100
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let event = EventListDataSource.shared.events[indexPath.row]
//        let eventDetails = EventDetailsState(authorImageData: event.avatarImage, repo: event.repo.name ?? "", authorName: event.author?.authorName ?? "")
//        let eventDetailsViewController = EventDetailsViewController(eventDetails: eventDetails)
//        self.navigationController?.pushViewController(eventDetailsViewController, animated: true)
//    }
//}
