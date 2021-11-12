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
    var page = 1
    let group = DispatchGroup()
    let queue = DispatchQueue(label: "test")
    
    override func loadView() {
        view = eventListContentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventListContentView.tableView.dataSource = dataSource
        eventListContentView.tableView.delegate = self
        setUpNavigation()
        
//        loadPageWithEvents()
        testWithDispatchGroup()
        
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
        print("начал работать getAllAvatars")
        DispatchQueue.concurrentPerform(iterations: self.dataSource.events.count, execute: { i in
            guard let imageUrl = self.dataSource.events[i].author?.avatarUrl else {
                return
            }
            NetworkClient.download(imageUrl).responseData { response in
                switch response.result {
                case .failure(let error):
                    print("Error while fetching the image: \(error)")
                case .success(let imageData):
                    self.dataSource.events[i].avatarImage = imageData
                    print("картинка номер \(i)")
//                    DispatchQueue.main.async { [weak self] in
//                        guard let self = self else { return }
//                        self.dataSource.events[i].avatarImage = imageData
//                        self.eventListContentView.tableView.reloadData()
//                    }
                }
            }
        })
        
    }
    
    func getEvents() {
        print("начал работать getEvents")
        self.getAllEvents(page: self.page) { [weak self] result in
            switch result {
            case .success(let events):
                if let self = self {
                    self.dataSource.events = events
                    print("event count = \(self.dataSource.events.count)")
                    // так как getAvatars не работает, то пока что вызов getAllAvatars отсюда
                    self.getAllAvatars()
                }
            case .failure(let error):
                print("Error - \(error)")
            }
        }
    }
    func getAvatars() {
        if self.dataSource.events.count > 0 {
            self.getAllAvatars()
        } else {
            print("Error - there are no events")
        }
    }
    
    func loadPageWithEvents() {
        let operationGetEvents = BlockOperation {
            print("1")
            self.getEvents()
        }
        operationGetEvents.completionBlock = {
            print("completionBlock: event count = \(self.dataSource.events.count)") // = 0
        }
        let operationGetAvatars = BlockOperation {
            print("2")
            self.getAvatars()
        }
        operationGetAvatars.addDependency(operationGetEvents)

        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.addOperations([operationGetEvents, operationGetAvatars], waitUntilFinished: true)
        operationQueue.addOperation {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                print("reloadData")
                self.eventListContentView.tableView.reloadData()
            }
        }
    }
    
    func testWithDispatchGroup() {
        group.enter()
        queue.sync {
            self.getEvents()
            self.group.leave()
        }
        group.enter()
        queue.sync {
            self.getAvatars()
            self.group.leave()
        }
        group.wait()
        group.notify(queue: DispatchQueue.main) {
            print("finish all")
            print("reloadData")
//                    DispatchQueue.main.async { [weak self] in
//                        guard let self = self else { return }
//                        self.eventListContentView.tableView.reloadData()
//                        print("reloadData")
//                    }
        }

    }
    
}
