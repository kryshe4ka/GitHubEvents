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
    
    let authorName: UILabel = {
        let authorName = UILabel()
        authorName.font = UIFont.boldSystemFont(ofSize: 16)
        authorName.textColor =  UIColor.lightGray
        authorName.translatesAutoresizingMaskIntoConstraints = false
        return authorName
    }()

    let repo: UILabel = {
        let repo = UILabel()
        repo.font = UIFont.boldSystemFont(ofSize: 16)
        repo.textColor =  UIColor.lightGray
        repo.translatesAutoresizingMaskIntoConstraints = false
        return repo
    }()
    
    init(event: Event) {
        super.init(frame: .zero)
        self.event = event
        if let imageData = event.avatarImage {
            authorImage.image = UIImage(data: imageData)
        }
        if let author = event.author {
            if let name = author.authorName {
                authorName.text = name
            }
        }
        if let repoName = event.repo.name {
            repo.text = repoName
        }
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }
    
    func createSubviews() {
        backgroundColor = .white
        addSubview(authorImage)
        addSubview(authorName)
        addSubview(repo)
        addConstrains()
    }
    
    func addConstrains() {
        NSLayoutConstraint.activate([
            authorImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            authorImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            authorImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            authorImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
}
