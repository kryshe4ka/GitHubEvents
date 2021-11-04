//
//  NetworkManager.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import Foundation

struct NetworkManager {
    
    static func fetchEvents(page: Int, completion: @escaping (_ events: [Event]?,_ error: String?)->()){
        guard let url = URL(string: "https://api.github.com/events?page=\(page)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode),
                  let data = data else {
                      print("response error")
                      completion(nil, "Please check your network connection.")
                      return
                  }
            //    Add JSON Decoding in URLSession closure
            let decoder = JSONDecoder()
            guard let events = try? decoder.decode([Event].self, from: data) else {
                print("unable to decode")
                return
            }
            // на этом этапе есть массис events, каждый элемент которого хранит ссылку на картинку, но картинка еще не загружена
            completion(events, nil)
        }.resume()
    }
    
    static func downloadImageData(imageUrl: String, completion: @escaping (_ imageData: Data?, _ error: String?)->()) {
        guard let imageUrl = URL(string: imageUrl) else {
          return
        }
        let task = URLSession.shared.downloadTask(with: imageUrl) { location, response, error in
          
            guard let location = location, let imageData = try? Data(contentsOf: location) else {
                print("imageData error")
                completion(nil, "Please check your data.")
                return
            }
            completion(imageData, nil)
        }
        task.resume()
    }    
}
