//
//  EventDetailsContentView.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 4.11.21.
//

import Foundation
import UIKit

class EventDetailsContentView: UIView {
    
    var event: Event?
    
    let authorImage: UIImageView = {
        let authorImage = UIImageView()
        authorImage.contentMode = .scaleAspectFill
        authorImage.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        authorImage.layer.cornerRadius = 35
        authorImage.clipsToBounds = true
        return authorImage
    }()
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        createSubviews()
//    }
    
    init(event: Event) {
        super.init(frame: .zero)
        self.event = event
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }
    
    func createSubviews() {
        backgroundColor = .yellow
        addSubview(authorImage)
        addConstrains()
    }
    
    func addConstrains() {
        NSLayoutConstraint.activate([
            authorImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            authorImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            authorImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            authorImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
    }
    
}
