//
//  EventListDataSource.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import Foundation
import UIKit

class EventListDataSource: NSObject, UITableViewDataSource {
    
    var data = ["1","2","3","4","5"]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = self.data[indexPath.row]
        return cell
    }
    
}
