//
//  GitHubEventsRouter.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 9.11.21.
//

import Foundation
import Alamofire

enum EventsRouter: URLRequestConvertible {
    
    enum Constants {
      static let baseURLPath = "https://api.github.com"
    }
    
    case events(Int)

    var method: HTTPMethod {
      switch self {
      case .events:
          return .get
      }
    }
    
    var path: String {
      switch self {
      case .events:
          return "/events"
      }
    }
    
    var parameters: [String: Any] {
      switch self {
      case .events(let page):
        return ["page": page]
      }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10*1000)
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
