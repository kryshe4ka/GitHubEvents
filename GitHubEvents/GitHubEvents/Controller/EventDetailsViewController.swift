//
//  EventDetailsViewController.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 4.11.21.
//

import UIKit

class EventDetailsViewController: UIViewController {

//    var eventDetailsContentView: EventDetailsContentView?
//    var event: Event?
//    var authorImage: UIImage?
    
//    init(event: Event, authorImage: UIImage) {
//        super.init(nibName: nil, bundle: nil)
//        self.eventDetailsContentView = EventDetailsContentView(event: event, image: authorImage)
//
//        self.event = event
//        self.authorImage = authorImage
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    override func loadView() {
//        view = eventDetailsContentView
//    }
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        view.addSubview(authorImage)
        authorImage.image = image
        
//        eventDetailsContentView?.authorImage.image = image

        
    }

    
}
