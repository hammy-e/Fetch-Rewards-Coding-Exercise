//
//  EventCell.swift
//  Fetch Rewards Coding Exercise
//
//  Created by Abraham Estrada on 5/19/21.
//

import UIKit
import SDWebImage

class EventCell: UITableViewCell {
    
    // MARK: - Properties
    
    var event: Event? {
        didSet{configure()}
    }
    
    private let image: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private let eventDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let favoriteHeart: UILabel = {
        let label = UILabel()
        label.text = "❤️"
        label.font = UIFont.systemFont(ofSize: 48)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(image)
        image.setDimensions(height: 100, width: 100)
        image.anchor(top: topAnchor, left: leftAnchor, paddingTop: 18, paddingLeft: 18)
        
        addSubview(eventDescription)
        eventDescription.anchor(top: topAnchor, left: image.rightAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let event = event else {return}
        
        image.sd_setImage(with: URL(string: event.imageURL))
        
        let attributedText = NSMutableAttributedString(string: "\(event.name)\n\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "\(event.location)\n\(event.date)", attributes: [.font: UIFont.boldSystemFont(ofSize: 15), .foregroundColor: UIColor.gray]))
        eventDescription.attributedText = attributedText
        
        if event.isFavorited {
            addSubview(favoriteHeart)
            favoriteHeart.anchor(top: topAnchor, left: leftAnchor, paddingTop: 3, paddingLeft: 3)
        } else {
            favoriteHeart.removeFromSuperview()
        }
    }
}
