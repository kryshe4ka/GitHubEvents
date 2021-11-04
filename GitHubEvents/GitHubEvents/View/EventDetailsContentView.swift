//
//  EventDetailsContentView.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 4.11.21.
//

import Foundation
import UIKit

class EventDetailsContentView: UIView {
    
    let authorImage: UIImageView = {
        let authorImage = UIImageView()
        authorImage.contentMode = .scaleAspectFill
        authorImage.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        authorImage.layer.cornerRadius = 35
        authorImage.clipsToBounds = true
        return authorImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
//    init(event: Event, image: UIImage) {
//        super.init(frame: .zero)
//        self.authorImage.image = image
//
//        createSubviews()
//    }
    
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
        
    }
    
}
