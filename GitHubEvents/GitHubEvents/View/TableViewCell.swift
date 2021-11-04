//
//  TableViewCell.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import UIKit

class TableViewCell: UITableViewCell {
    
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
                    if let avatarUrl = author.avatarUrl {
                        displayAuthorAvatar(avatarUrl: avatarUrl)
                    }
                    if let name = author.authorName {
                        authorName.text = name
                    }
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        contentView.addSubview(authorImage)
        contentView.addSubview(containerView)
        containerView.addSubview(eventType)
        containerView.addSubview(authorName)
        containerView.addSubview(eventDate)
        
        contentView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        authorImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        authorImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:10).isActive = true
        authorImage.widthAnchor.constraint(equalToConstant:70).isActive = true
        authorImage.heightAnchor.constraint(equalToConstant:70).isActive = true
        
        containerView.leadingAnchor.constraint(equalTo:self.authorImage.trailingAnchor, constant:10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
        containerView.topAnchor.constraint(equalTo:self.topAnchor, constant:10).isActive = true
        containerView.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant:-10).isActive = true


        eventType.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        eventType.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        eventType.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true

        authorName.topAnchor.constraint(equalTo:self.eventType.bottomAnchor).isActive = true
        authorName.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        
        eventDate.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor).isActive = true
        eventDate.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayAuthorAvatar(avatarUrl: String) {
      guard let avatarUrl = URL(string: avatarUrl) else {
        return
      }
      let task = URLSession.shared.downloadTask(with: avatarUrl) { location, response, error in
        
        guard let location = location,
              let imageData = try? Data(contentsOf: location),
          let image = UIImage(data: imageData) else {
            return
        }
        DispatchQueue.main.async {
          self.authorImage.image = image
        }
      }
      task.resume()
    }
}
