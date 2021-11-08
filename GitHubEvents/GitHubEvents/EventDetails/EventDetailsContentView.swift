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
    var imageHeightConstraitCompact = NSLayoutConstraint()
    var imageHeightConstraitRegular = NSLayoutConstraint()
    
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
        repo.allowsDefaultTighteningForTruncation = true
        repo.textAlignment = .center
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
        addConstraints()
        
        imageHeightConstraitCompact = authorImage.heightAnchor.constraint(equalToConstant: 200)
        imageHeightConstraitRegular = authorImage.heightAnchor.constraint(equalToConstant: 310)
        if UIDevice.current.orientation.isLandscape {
            activateConstraitsForCompact()
        } else {
            activateConstraitsForRegular()
        }
    }
    
    func activateConstraitsForRegular() {
        imageHeightConstraitCompact.isActive = false
        imageHeightConstraitRegular.isActive = true
    }
    
    func activateConstraitsForCompact() {
        imageHeightConstraitRegular.isActive = false
        imageHeightConstraitCompact.isActive = true
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            authorImage.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            authorImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            authorImage.widthAnchor.constraint(equalTo: authorImage.heightAnchor),
            repo.centerXAnchor.constraint(equalTo: centerXAnchor),
            repo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            repo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            repo.topAnchor.constraint(equalTo: authorImage.bottomAnchor, constant: 20),
            authorName.topAnchor.constraint(equalTo: repo.bottomAnchor, constant: 20),
            authorName.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
