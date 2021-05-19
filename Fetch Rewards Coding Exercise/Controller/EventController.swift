//
//  EventController.swift
//  Fetch Rewards Coding Exercise
//
//  Created by Abraham Estrada on 5/19/21.
//

import UIKit

class EventController: UIViewController {
    
    // MARK: - Properties
    
    var event: Event? {
        didSet{configure()}
    }
    
    private let image: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private let eventDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Favorite❤️", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setDimensions(height: 50, width: 150)
        button.backgroundColor = #colorLiteral(red: 0.9107013345, green: 0.905287683, blue: 0.9148628116, alpha: 1)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(handleFavoriteTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        view.backgroundColor = .white
        
        view.addSubview(image)
        image.setDimensions(height: view.frame.width - 100, width: view.frame.width - 100)
        image.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50)
        
        view.addSubview(eventDescription)
        eventDescription.setWidth(view.frame.width)
        eventDescription.anchor(top: image.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        view.addSubview(favoriteButton)
        favoriteButton.centerX(inView: view)
        favoriteButton.anchor(top: eventDescription.bottomAnchor, paddingTop: 24)
    }
    
    // MARK: - Actions
    
    @objc func handleFavoriteTapped() {
        guard let event = event else {return}
        var favoritedEvents = UserDefaults.standard.array(forKey: FAVORITEDEVENTSKEY) as? [Int] ?? [Int]()
        if event.isFavorited {
            favoriteButton.backgroundColor = #colorLiteral(red: 0.9107013345, green: 0.905287683, blue: 0.9148628116, alpha: 1)
            favoritedEvents.removeAll(where: {$0 == event.id})
            UserDefaults.standard.removeObject(forKey: FAVORITEDEVENTSKEY)
            UserDefaults.standard.set(favoritedEvents, forKey: FAVORITEDEVENTSKEY)
        } else {
            favoriteButton.backgroundColor = #colorLiteral(red: 0.9660039544, green: 0.5945872664, blue: 0.55089885, alpha: 1)
            favoritedEvents.append(event.id)
            UserDefaults.standard.removeObject(forKey: FAVORITEDEVENTSKEY)
            UserDefaults.standard.set(favoritedEvents, forKey: FAVORITEDEVENTSKEY)
        }
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let event = event else {return}
        
        navigationItem.title = event.name
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        image.sd_setImage(with: URL(string: event.imageURL))
        
        let attributedText = NSMutableAttributedString(string: "\(event.date)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 28), .foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "\(event.location)", attributes: [.font: UIFont.boldSystemFont(ofSize: 24), .foregroundColor: UIColor.gray]))
        eventDescription.attributedText = attributedText
        
        favoriteButton.backgroundColor = event.isFavorited ? #colorLiteral(red: 0.9660039544, green: 0.5945872664, blue: 0.55089885, alpha: 1) : #colorLiteral(red: 0.9107013345, green: 0.905287683, blue: 0.9148628116, alpha: 1)
    }
}