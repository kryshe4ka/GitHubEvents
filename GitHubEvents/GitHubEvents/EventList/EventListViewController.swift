//
//  ViewController.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//


import UIKit
import Alamofire
import Foundation

public func getAllEvents(page: Int, completion: @escaping (Result<[Event], Error>) -> Void) {
    NetworkClient.request(EventsRouter.events(page)).responseDecodable(of: [Event].self) { response in
        switch response.result {
        case .success(let events):
            completion(.success(events))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

class EventListViewController: UIViewController {
    var eventListContentView = EventListContentView()
    var dataSource = EventListDataSource()
    var page = 1
    let group = DispatchGroup()
    
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

        group.enter()
        getAllEvents(page: self.page) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let events):
                    self.dataSource.events = events
                    print(events.count)
                    self.getAllAvatars()
                    self.group.leave()
            case .failure(let error):
                    print("Error - \(error)")
                    self.group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print("Finished all upload requests.")
            self.eventListContentView.tableView.reloadData()
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

// MARK: - Networking calls
extension EventListViewController {

    func getAllAvatars() {
        DispatchQueue.concurrentPerform(iterations: self.dataSource.events.count, execute: { i in
            guard let imageUrl = self.dataSource.events[i].author?.avatarUrl else {
                return
            }
            self.group.enter()
            NetworkClient.download(imageUrl).responseData { response in
                switch response.result {
                case .failure(let error):
                    print("Error while fetching the image: \(error)")
                case .success(let imageData):
                    self.dataSource.events[i].avatarImage = imageData
                    self.group.leave()
                }
            }
        })
    }
}

















//
//import UIKit
//import Alamofire
//import Foundation
//
//public func getAllEvents(page: Int, completion: @escaping (Result<[Event], Error>) -> Void) {
//    NetworkClient.request(EventsRouter.events(page)).responseDecodable(of: [Event].self) { response in
//        switch response.result {
//        case .success(let events):
//            completion(.success(events))
//        case .failure(let error):
//            completion(.failure(error))
//        }
//    }
//}
//public func getAllAvatars(events: [Event]) {
//    var imagesDataArray: [Data] = []
//    DispatchQueue.concurrentPerform(iterations: events.count, execute: { i in
//        guard let imageUrl = events[i].author?.avatarUrl else {
//            return
//        }
//        NetworkClient.download(imageUrl).responseData { response in
//            switch response.result {
//            case .failure(let error):
//                print("Error while fetching the image: \(error)")
//            case .success(let imageData):
//                imagesDataArray.append(imageData)
//                print("картинка номер \(i)")
////                    DispatchQueue.main.async { [weak self] in
////                        guard let self = self else { return }
////                        self.dataSource.events[i].avatarImage = imageData
////                        self.eventListContentView.tableView.reloadData()
////                    }
//            }
//        }
//    })
//}
//
//class GetEventsOperation: AsynchronousOperation {
//    let page: Int
//    var result: Result<[Event], Error>?
//
//    init(page: Int) {
//        self.page = page
//        super.init()
//    }
//    override func main() {
//        getAllEvents(page: page) { result in
//            self.result = result
//            self.state = .finished
//        }
//    }
//}
//
//class SecondOperation: AsynchronousOperation {
//
//}
//
//
//
//class EventListViewController: UIViewController {
//
//    var eventListContentView = EventListContentView()
//    var dataSource = EventListDataSource()
//    let operationQueue = OperationQueue()
//    var page = 1
//    let group = DispatchGroup()
//    let queue = DispatchQueue(label: "test")
//
//
//
//    func getEvents() {
//        let operation = GetEventsOperation(page: page)
//        operation.completionBlock = { [weak self] in
//            guard let result = operation.result else { return }
//            switch result {
//            case .success(let events):
//                if let self = self {
//                    self.dataSource.events = events
//                    print("event count = \(self.dataSource.events.count)")
////                    self.getAllAvatars()
//                }
//            case .failure(let error):
//                print("Error - \(error)")
//            }
//        }
////        operation.start()
//        operationQueue.addOperation(operation)
//    }
//
//
//
//    override func loadView() {
//        view = eventListContentView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        eventListContentView.tableView.dataSource = dataSource
//        eventListContentView.tableView.delegate = self
//        setUpNavigation()
//
//        getEvents()
//
//
////        loadPageWithEvents()
////        testWithDispatchGroup()
//
//
//
//    }
//
//    func setUpNavigation() {
//        self.navigationItem.title = "Table of events"
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
//    }
//}
//
//// MARK: - UITableViewDelegate
//extension EventListViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//       return 100
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let eventDetailsViewController = EventDetailsViewController(event: dataSource.events[indexPath.row])
//        self.navigationController?.pushViewController(eventDetailsViewController, animated: true)
//    }
//}
//
//// MARK: - Networking calls
//extension EventListViewController {
//    func getAllEvents(page: Int, completion: @escaping (Result<[Event], Error>) -> Void) {
//        NetworkClient.request(EventsRouter.events(page)).responseDecodable(of: [Event].self) { response in
//            switch response.result {
//            case .success(let events):
//                completion(.success(events))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func getAllAvatars() {
//        print("начал работать getAllAvatars")
//
//        DispatchQueue.concurrentPerform(iterations: self.dataSource.events.count, execute: { i in
//            guard let imageUrl = self.dataSource.events[i].author?.avatarUrl else {
//                return
//            }
//            NetworkClient.download(imageUrl).responseData { response in
//                self.group.enter()
//                switch response.result {
//                case .failure(let error):
//                    print("Error while fetching the image: \(error)")
//                case .success(let imageData):
//                    self.dataSource.events[i].avatarImage = imageData
//                    print("картинка номер \(i)")
//                    self.group.leave()
////                    DispatchQueue.main.async { [weak self] in
////                        guard let self = self else { return }
////                        self.dataSource.events[i].avatarImage = imageData
////                        self.eventListContentView.tableView.reloadData()
////                    }
//                }
//            }
//        })
//    }
//
//
//    func getAvatars() {
//        if self.dataSource.events.count > 0 {
//            self.getAllAvatars()
//        } else {
//            print("Error - there are no events")
//        }
//    }
//
//    func loadPageWithEvents() {
//        let operationGetEvents = BlockOperation {
//            print("1")
//            self.getEvents()
//        }
//        operationGetEvents.completionBlock = {
//            print("completionBlock: event count = \(self.dataSource.events.count)") // = 0
//        }
//        let operationGetAvatars = BlockOperation {
//            print("2")
//            self.getAvatars()
//        }
//        operationGetAvatars.addDependency(operationGetEvents)
//
//        operationQueue.maxConcurrentOperationCount = 1
//        operationQueue.addOperations([operationGetEvents, operationGetAvatars], waitUntilFinished: true)
//        operationQueue.addOperation {
//            DispatchQueue.main.async { [weak self] in
//                guard let self = self else { return }
//                print("reloadData")
//                self.eventListContentView.tableView.reloadData()
//            }
//        }
//    }
//
//    func testWithDispatchGroup() {
//        group.enter()
//        queue.sync {
//            self.getEvents()
//        }
//        group.enter()
//        queue.sync {
//            self.getAvatars()
//        }
//        group.wait()
//        group.notify(queue: DispatchQueue.main) {
//            print("finish all")
//            print("reloadData")
////                    DispatchQueue.main.async { [weak self] in
////                        guard let self = self else { return }
////                        self.eventListContentView.tableView.reloadData()
////                        print("reloadData")
////                    }
//        }
//
//    }
//
//}
