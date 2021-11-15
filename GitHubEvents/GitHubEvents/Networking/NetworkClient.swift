//
//  NetworkClient.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 9.11.21.
//

import Foundation
import Alamofire
import UIKit

struct NetworkClient {
    static let shared = NetworkClient()
    static let group = DispatchGroup()
    let session: Session
  
    init() {
    self.session = Session()
    }
    
    static func request(_ convertible: URLRequestConvertible) -> DataRequest {
      shared.session.request(convertible).validate()
    }
    
    static func download(_ url: String) -> DownloadRequest {
      shared.session.download(url).validate()
    }
}

extension NetworkClient {
    static func getEvents(page: Int, tableView: UITableView, completion: @escaping ([Event]) -> Void ) {
        group.enter()
        var eventsWithAvatars: [Event] = []
        getAllEvents(page: page) { result in
            switch result {
            case .success(let events):
                eventsWithAvatars = events
                if eventsWithAvatars.count != 0 {
                    DispatchQueue.concurrentPerform(iterations: eventsWithAvatars.count, execute: { i in
                        group.enter()
                        guard let imageUrl = eventsWithAvatars[i].author?.avatarUrl else {
                            return
                        }
                        NetworkClient.download(imageUrl).responseData { response in
                            switch response.result {
                            case .failure(let error):
                                print("Error while fetching the image: \(error)")
                            case .success(let imageData):
                                eventsWithAvatars[i].avatarImage = imageData
                                group.leave()
                            }
                        }
                    })
                }
                group.leave()
            case .failure(let error):
                print("Error - \(error)")
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(eventsWithAvatars)
            print("Finished all upload requests.")
            tableView.reloadData()
        }
    }
}

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
