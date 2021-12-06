//
//  ContentView.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import Foundation
import UIKit

class EventListContentView: UIView {
    let refreshControl = UIRefreshControl()
    
    let menuBar = MenuBarView(withTitles: EventListDataSource.menuTitles)
    var menuHeight: CGFloat = 40
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventListTableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }
    
    func createSubviews() {
        backgroundColor = .white
        addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        addConstrains()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.addSubview(refreshControl)
    }
        
    func addConstrains() {
        NSLayoutConstraint.activate([
            menuBar.heightAnchor.constraint(equalToConstant: menuHeight),
            menuBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: menuHeight),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
