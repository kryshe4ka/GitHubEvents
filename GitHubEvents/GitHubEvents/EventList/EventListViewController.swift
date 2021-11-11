//
//  ViewController.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import UIKit
import Alamofire

class EventListViewController: UIViewController {

    var eventListContentView = EventListContentView()
    var dataSource = EventListDataSource()
    let operationQueue = OperationQueue()
    
    override func loadView() {
        view = eventListContentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventListContentView.tableView.dataSource = dataSource
        eventListContentView.tableView.delegate = self
        setUpNavigation()
        
    // ресурсозатратная операция? вроде да, но я не вижу разницы в результате, если делать с operationQueue
        operationQueue.addOperation { [weak self] in
            guard let self = self else {return}
            self.getAllEvents(page: 1) { [weak self] result in
                switch result {
                case .success(let events):
                    if let self = self {
                        self.dataSource.events = events
                        self.getAllAvatars()
                    }
                case .failure(let error):
                    print("Error - \(error)")
                }
            }
        }
//        getAllEvents(page: 1) { [weak self] result in
//            switch result {
//            case .success(let events):
//                if let self = self {
//                    self.dataSource.events = events
//                    self.getAllAvatars()
//                }
//            case .failure(let error):
//                print("Error - \(error)")
//            }
//        }
    }
        
    func setUpNavigation() {
        self.navigationItem.title = "Table of events"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
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

// MARK: - Networking calls
extension EventListViewController {
    func getAllEvents(page: Int, completion: @escaping (Result<[Event], Error>) -> Void) {
        NetworkClient.request(EventsRouter.events(page)).responseDecodable(of: [Event].self) { response in
            switch response.result {
            case .success(let events):
                completion(.success(events))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getAllAvatars() {
        DispatchQueue.concurrentPerform(iterations: self.dataSource.events.count, execute: { i in
            guard let imageUrl = self.dataSource.events[i].author?.avatarUrl else {
                return
            }
            NetworkClient.download(imageUrl).responseData { response in
                switch response.result {
                case .failure(let error):
                    print("Error while fetching the image: \(error)")
                case .success(let imageData):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.dataSource.events[i].avatarImage = imageData
                        self.eventListContentView.tableView.reloadData()
                    }
                }
            }
        })
    }
}
