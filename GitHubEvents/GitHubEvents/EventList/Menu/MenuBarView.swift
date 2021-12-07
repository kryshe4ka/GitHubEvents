//
//  MenuBarView.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 6.12.21.
//

import UIKit

class MenuBarView: UIView {
        
    let menuTitles: [String]
    let accentColor  = EventListDataSource.shared.accentColor
    var indicatorView = UIView()
    let indicatorHeight : CGFloat = 3
    let menuHeight: CGFloat = 40
    var selectedIndex = 0
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    
    var menuCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let menuCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        menuCollection.register(EventTypeMenuCell.self, forCellWithReuseIdentifier: EventTypeMenuCell.reuseIdentifier)
        menuCollection.translatesAutoresizingMaskIntoConstraints = false
        return menuCollection
    }()
    
    init(withTitles titles: [String]) {
        self.menuTitles = titles
        super.init(frame: .zero)
        createMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    func createMenu() {
        /// add collection view and setup constraints
        addSubview(menuCollection)
        NSLayoutConstraint.activate([
            menuCollection.topAnchor.constraint(equalTo: topAnchor),
            menuCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            menuCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuCollection.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        /// add indicator view under selected type
        indicatorView.backgroundColor = accentColor
        indicatorView.frame = CGRect(x: menuCollection.bounds.minX, y: menuHeight - indicatorHeight, width: UIScreen.main.bounds.width / CGFloat(menuTitles.count), height: indicatorHeight)
        menuCollection.addSubview(indicatorView)
        
        // возможно нужно перенести жесты на вью общую (контент вью)
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
//        tableView.reloadData()
        
        let desiredX = (menuCollection.bounds.width / CGFloat(menuTitles.count)) * CGFloat(selectedIndex)
        UIView.animate(withDuration: 0.3) {
             self.indicatorView.frame = CGRect(x: desiredX, y: self.menuCollection.bounds.maxY - self.indicatorHeight, width: self.menuCollection.bounds.width / CGFloat(self.menuTitles.count), height: self.indicatorHeight)
        }
    }
}
