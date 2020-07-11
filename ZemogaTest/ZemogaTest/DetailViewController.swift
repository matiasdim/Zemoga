//
//  DetailViewController.swift
//  ZemogaTest
//
//  Created by Matías Gil Echavarría on 7/10/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit

protocol PostManagmentDelegate: AnyObject {
    func favoriteButtonPressed(for post: Post)
}

class DetailViewController: UIViewController {
    var refreshButton: UIBarButtonItem!
    var post: Post
    weak var delegate: PostManagmentDelegate?
//    var imageName: String = "" {
//        didSet {
//            //Once favorite image name is set to star (default name),it automatically checks if product is faorited to change image for a filled star and viceversa
//            if let favorite = self.post.favorite, favorite {
//                self.imageName += ".fill"
//            }
//        }
//    }
    
    init(post: Post, delegate: PostManagmentDelegate) {
        self.post = post
        self.delegate = delegate
//        self.imageName = "star"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = .white
        
        self.navigationItem.title = "Post"
        self.refreshButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.toggleFavorite))
        self.refreshButton.tintColor = .white

        self.refreshButton.image = UIImage(systemName: self.setStarIconName(isFavorite: self.post.favorite))

        self.navigationItem.rightBarButtonItem = refreshButton
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    @objc private func toggleFavorite() {
        if let favorite = self.post.favorite {
            self.refreshButton.image = UIImage(systemName: self.setStarIconName(isFavorite: !favorite))
        }
        self.delegate?.favoriteButtonPressed(for: self.post)
    }

    private func setStarIconName(isFavorite: Bool?) -> String {
        var imageName = "star"
        if let isFavorite = isFavorite, isFavorite {
            imageName += ".fill"
        }
        return imageName
    }

}
