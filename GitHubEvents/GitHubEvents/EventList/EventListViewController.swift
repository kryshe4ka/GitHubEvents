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
            case .failure(let error):
                print(error)
            }
        }
    }
}
