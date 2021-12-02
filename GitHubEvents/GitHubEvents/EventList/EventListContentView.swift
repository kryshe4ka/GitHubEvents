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
    let menuTitles = EventListDataSource.menuTitles
    var indicatorView = UIView()
    let indicatorHeight : CGFloat = 3
    var selectedIndex = 0
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    
    var menuCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let menuCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        menuCollection.register(EventTypeMenuCell.self, forCellWithReuseIdentifier: EventTypeMenuCell.reuseIdentifier)
        menuCollection.translatesAutoresizingMaskIntoConstraints = false
        return menuCollection
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventListTableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
        createMenu()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
        createMenu()
    }
    
    func createSubviews() {
        backgroundColor = .white
        addSubview(tableView)
        addConstrains()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.addSubview(refreshControl)
    }
    
    func addConstrains() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func createMenu() {
        addSubview(menuCollection)
        /// add indicator view under selected type
        indicatorView.backgroundColor = .red
        NSLayoutConstraint.activate([
            menuCollection.heightAnchor.constraint(equalToConstant: 40),
            menuCollection.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            menuCollection.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            menuCollection.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        indicatorView.frame = CGRect(x: menuCollection.bounds.minX, y: 40 - indicatorHeight, width: UIScreen.main.bounds.width / CGFloat(menuTitles.count), height: indicatorHeight)
        menuCollection.addSubview(indicatorView)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        leftSwipe.direction = .left
        addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        rightSwipe.direction = .right
        addGestureRecognizer(rightSwipe)
    }
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            if selectedIndex < menuTitles.count - 1 {
                selectedIndex += 1
            }
        } else {
            if selectedIndex > 0 {
                selectedIndex -= 1
            }
        }
        selectedIndexPath = IndexPath(item: selectedIndex, section: 0)
        menuCollection.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredVertically)
        refreshContent()
    }
    
    func refreshContent(){
        /// configure events array
        EventListDataSource.shared.selectedIndex = selectedIndex
        EventListDataSource.shared.filterEvents()
        /// refresh table with selected type of events
        tableView.reloadData()
        
        let desiredX = (menuCollection.bounds.width / CGFloat(menuTitles.count)) * CGFloat(selectedIndex)
        UIView.animate(withDuration: 0.3) {
             self.indicatorView.frame = CGRect(x: desiredX, y: self.menuCollection.bounds.maxY - self.indicatorHeight, width: self.menuCollection.bounds.width / CGFloat(self.menuTitles.count), height: self.indicatorHeight)
        }
    }
}
