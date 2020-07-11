//
//  DetailViewController.swift
//  ZemogaTest
//
//  Created by Matías Gil Echavarría on 7/10/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var refreshButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = .white
        
        self.navigationItem.title = "Post"
        self.refreshButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.toggleFavorite))
        self.refreshButton.tintColor = .white
        self.refreshButton.image = UIImage(systemName: "star") // Add star filled or not based on object attribute
        self.navigationItem.rightBarButtonItem = refreshButton
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
//        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "close")
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "close")
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    @objc private func toggleFavorite() {
        self.refreshButton.image = UIImage(systemName: "star.fill") // Add star filled or not based on object attribute
    }


}
