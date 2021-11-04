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
        authorImage.translatesAutoresizingMaskIntoConstraints = false
        authorImage.layer.cornerRadius = 35
        authorImage.clipsToBounds = true
        return authorImage
    }()
    
    let authorName: UILabel = {
        let authorName = UILabel()
        authorName.font = UIFont.boldSystemFont(ofSize: 22)
        authorName.textColor =  UIColor.red
        authorName.translatesAutoresizingMaskIntoConstraints = false
        return authorName
    }()

    let repo: UILabel = {
        let repo = UILabel()
        repo.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .light)
        repo.textColor =  UIColor.link
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
                authorName.text = "Author: " + name
            }
        }
        if let repoName = event.repo.name {
            repo.text = "Repo: " + repoName
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
        let width = UIScreen.main.bounds.height / 2.5
        NSLayoutConstraint.activate([
            authorImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            authorImage.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            authorImage.heightAnchor.constraint(equalToConstant: width),
            authorImage.widthAnchor.constraint(equalToConstant: width),
            
            repo.centerXAnchor.constraint(equalTo: centerXAnchor),
            repo.topAnchor.constraint(equalTo: authorImage.bottomAnchor, constant: 20),
            
            authorName.topAnchor.constraint(equalTo: repo.bottomAnchor, constant: 40),
            authorName.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ])
    }
    
}
