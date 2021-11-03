//
//  EventListDataSource.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import UIKit

class EventListDataSource: NSObject, UITableViewDataSource {
    
    var events: [Event] = []
    
    func fetchEvents() {
        guard let url = URL(string: "https://api.github.com/events?page=1") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode),
                  let data = data else {
                      print("response error")
                      fatalError()
                  }
                        
            //    Add JSON Decoding in URLSession closure
            let decoder = JSONDecoder()
            guard let events = try? decoder.decode([Event].self, from: data) else {
                print("decoder error")
                return
            }
            
            //    Update event items on main thread
            DispatchQueue.main.async {
                self.events = events
            }
            
        }.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = self.events[indexPath.row].id
        return cell
    }
    
}
