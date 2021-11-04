//
//  EventDetailsViewController.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 4.11.21.
//

import UIKit

class EventDetailsViewController: UIViewController {

    var eventDetailsContentView: EventDetailsContentView?
//    var event: Event?
    
    init(event: Event) {
        super.init(nibName: nil, bundle: nil)
        self.eventDetailsContentView = EventDetailsContentView(event: event)
//        self.event = event
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = eventDetailsContentView
    }
    
    
    var image = UIImage()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        authorName.text = event?.author?.authorName
        repo.text = event?.repo.name
        
        view.addSubview(authorImage)
        view.addSubview(authorName)
        view.addSubview(repo)

        
        authorImage.image = image
        addConstrains()
//        eventDetailsContentView?.authorImage.image = image

        
    }
    
    func addConstrains() {
        print("liza1")
        NSLayoutConstraint.activate([
            authorImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            authorImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            authorImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            authorImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),


        ])
        
    }

    
}
