//
//  ContentView.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 6.12.21.
//

import Foundation
import UIKit

class ContentView: UIView {
            
    lazy var contentCollection: UICollectionView = {
        /// setup collection layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let contentCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        contentCollection.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: ContentCollectionViewCell.reuseIdentifier)
        contentCollection.translatesAutoresizingMaskIntoConstraints = false
        contentCollection.showsHorizontalScrollIndicator = true
        contentCollection.isPagingEnabled = true // for "pages" behavior
        contentCollection.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: ContentCollectionViewCell.reuseIdentifier)
        return contentCollection
    }()
    
    init(withEvents events: [Event]) {
        super.init(frame: .zero)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView() {
        addSubview(contentCollection)
        NSLayoutConstraint.activate([
            contentCollection.topAnchor.constraint(equalTo: topAnchor),
            contentCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentCollection.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
