//
//  TableViewCell.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import UIKit

class EventListTableViewCell: UITableViewCell {
    
    var event:Event? {
            didSet {
                guard let eventItem = event else {return}
                if let type = eventItem.type {
                    eventType.text = type
                }
                if let date = eventItem.date {
                    eventDate.text = date
                }
                if let author = eventItem.author {
                    if let name = author.authorName {
                        authorName.text = name
                    }
                }
                if let imageData = eventItem.avatarImage {
                    authorImage.image = UIImage(data: imageData)
                }
            }
    }
    
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
    let eventType: UILabel = {
        let eventType = UILabel()
        eventType.font = UIFont.boldSystemFont(ofSize: 20)
        eventType.textColor = UIColor.darkGray
        eventType.clipsToBounds = true
        eventType.translatesAutoresizingMaskIntoConstraints = false
       return eventType
    }()
    let eventDate: UILabel = {
        let eventDate = UILabel()
        eventDate.font = UIFont.boldSystemFont(ofSize: 14)
        eventDate.textColor =  UIColor.black
        eventDate.translatesAutoresizingMaskIntoConstraints = false
        return eventDate
    }()
    let containerView: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.clipsToBounds = true // this will make sure its children do not go out of the boundary
      return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        contentView.addSubview(authorImage)
        contentView.addSubview(containerView)
        containerView.addSubview(eventType)
        containerView.addSubview(authorName)
        containerView.addSubview(eventDate)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            authorImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            authorImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:10),
            authorImage.widthAnchor.constraint(equalToConstant:70),
            authorImage.heightAnchor.constraint(equalToConstant:70),
            
            containerView.leadingAnchor.constraint(equalTo:self.authorImage.trailingAnchor, constant:10),
            containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10),
            containerView.topAnchor.constraint(equalTo:self.topAnchor, constant:10),
            containerView.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant:-10),

            eventType.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            eventType.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            eventType.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),

            authorName.topAnchor.constraint(equalTo:self.eventType.bottomAnchor),
            authorName.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor),
            
            eventDate.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor),
            eventDate.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor),
        ])
    }
}
