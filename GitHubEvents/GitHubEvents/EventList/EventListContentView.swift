//
//  ContentView.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import Foundation
import UIKit

class EventListContentView: UIView {
    var menuHeight: CGFloat = 40
    let menuBar: MenuBarView = {
        let menuBar = MenuBarView(withTitles: EventListDataSource.shared.menuTitles)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        return menuBar
    }()
    let contentView: ContentView = {
        let contentView = ContentView(withEvents: EventListDataSource.shared.events)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    func setupSubviews() {
        backgroundColor = .white
        addSubview(menuBar)
        addSubview(contentView)
        addConstrains()
    }
        
    func addConstrains() {
        NSLayoutConstraint.activate([
            menuBar.heightAnchor.constraint(equalToConstant: menuHeight),
            menuBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: menuHeight),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
