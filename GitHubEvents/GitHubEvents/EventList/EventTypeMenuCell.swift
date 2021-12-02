//
//  EventTypeMenu.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 1.12.21.
//

import Foundation
import UIKit

final class EventTypeMenuCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: EventTypeMenuCell.self)
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.alpha = 0.6
        return titleLabel
    }()
    
    func setupCell(text: String) {
        titleLabel.text = text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(titleLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet{
            titleLabel.alpha = isSelected ? 1.0 : 0.6
            titleLabel.textColor = isSelected ? .red : .black
        }
    }
    
    func setupConstraints() {        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
