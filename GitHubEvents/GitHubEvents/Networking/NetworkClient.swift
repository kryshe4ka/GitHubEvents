//
//  NetworkClient.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 9.11.21.
//

import Foundation
import Alamofire

struct NetworkClient {
    static let shared = NetworkClient()
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
