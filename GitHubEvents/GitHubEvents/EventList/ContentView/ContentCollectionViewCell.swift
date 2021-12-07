//
//  ContentCollectionViewCell.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 6.12.21.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: ContentCollectionViewCell.self)
    var selectedIndex = 0
    var page = 1
    let pageMAX = 10
    var controller: EventListViewController?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshEventList(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventListTableViewCell.self, forCellReuseIdentifier: EventListTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    func setupCell(selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        tableView.addSubview(refreshControl)
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        getNetworkEvents(table: tableView)
    }
    
    @objc func refreshEventList(_ sender: AnyObject) {
        getNetworkEvents(table: tableView)
    }
    
    func getNetworkEvents(table: UITableView) {
        let page = 1
        NetworkClient.getEvents(page: page, tableView: table) { [weak self] events in
            guard let self = self else { return }
            EventListDataSource.shared.refreshEvents(with: events)
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDelegate
extension ContentCollectionViewCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row <= EventListDataSource.shared.filteredEvents[selectedIndex].count-1 {
            let event = EventListDataSource.shared.filteredEvents[selectedIndex][indexPath.row]
            let eventDetails = EventDetailsState(authorImageData: event.avatarImage, repo: event.repo.name ?? "", authorName: event.author?.authorName ?? "")
            let eventDetailsViewController = EventDetailsViewController(eventDetails: eventDetails)
            guard let controller = controller else { return }
            controller.navigationController?.pushViewController(eventDetailsViewController, animated: true)
        }
    }
}

extension ContentCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        EventListDataSource.shared.filteredEvents[selectedIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventListTableViewCell.reuseIdentifier, for: indexPath) as! EventListTableViewCell
        if indexPath.row <= EventListDataSource.shared.filteredEvents[selectedIndex].count-1 {
            let event = EventListDataSource.shared.filteredEvents[selectedIndex][indexPath.row]
            let state = CellState(authorImageData: event.avatarImage, date: event.date ?? "", type: event.type ?? "", authorName: event.author?.authorName ?? "")
            cell.update(state: state)
        }
        /// Check if the last row number is the same as the last current data element
        if indexPath.row == EventListDataSource.shared.filteredEvents[selectedIndex].count - 1 && page <= pageMAX {
            loadMore(tableView)
            print("Load more for current tableView")
        }
        return cell
    }
    
    func loadMore(_ tableView: UITableView) {
        page += 1
        NetworkClient.getEvents(page: page, tableView: tableView) { events in
            EventListDataSource.shared.addMoreEvents(withEvents: events)
        }
    }
}
