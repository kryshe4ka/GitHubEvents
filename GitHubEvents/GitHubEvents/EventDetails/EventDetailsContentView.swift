//
//  EventDetailsContentView.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 4.11.21.
//

import Foundation
import UIKit

struct EventDetailsState {
    let authorImageData: Data?
    let repo: String
    let authorName: String
}

class EventDetailsContentView: UIView {
    
    var imageHeightConstraitCompact = NSLayoutConstraint()
    var imageHeightConstraitRegular = NSLayoutConstraint()
    var imageTopConstraitCompact = NSLayoutConstraint()
    var imageTopConstraitRegular = NSLayoutConstraint()
    
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
        authorName.numberOfLines = 0
        return authorName
    }()

    let repo: UILabel = {
        let repo = UILabel()
        repo.font = UIFont.systemFont(ofSize: 16)
        repo.textColor =  UIColor.systemBlue
        repo.translatesAutoresizingMaskIntoConstraints = false
        repo.allowsDefaultTighteningForTruncation = true
        repo.textAlignment = .center
        repo.numberOfLines = 0
        return repo
    }()
    
    init() {
        super.init(frame: .zero)
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
        imageHeightConstraitCompact = authorImage.heightAnchor.constraint(equalToConstant: 180)
        imageHeightConstraitRegular = authorImage.heightAnchor.constraint(equalToConstant: 310)
        imageTopConstraitCompact = authorImage.topAnchor.constraint(equalTo: topAnchor, constant: 40)
        imageTopConstraitRegular = authorImage.topAnchor.constraint(equalTo: topAnchor, constant: 100)
        if UIDevice.current.orientation.isLandscape {
            activateConstraitsForCompact()
        } else {
            activateConstraitsForRegular()
        }
    }
    
    func activateConstraitsForRegular() {
        imageHeightConstraitCompact.isActive = false
        imageHeightConstraitRegular.isActive = true
        imageTopConstraitCompact.isActive = false
        imageTopConstraitRegular.isActive = true
    }
    
    func activateConstraitsForCompact() {
        imageHeightConstraitRegular.isActive = false
        imageHeightConstraitCompact.isActive = true
        imageTopConstraitCompact.isActive = true
        imageTopConstraitRegular.isActive = false
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
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
    
    func update(state: EventDetailsState) {
        repo.text = "Repo: " + state.repo
        authorName.text = "Author: " + state.authorName
        if let imageData = state.authorImageData {
            authorImage.image = UIImage(data: imageData)
        } else {
            authorImage.image = UIImage(named: "Portrait_Placeholder")
        }
    }
}
