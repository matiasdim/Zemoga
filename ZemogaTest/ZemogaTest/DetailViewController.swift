//
//  DetailViewController.swift
//  ZemogaTest
//
//  Created by Matías Gil Echavarría on 7/10/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = .white
        
        self.navigationItem.title = "Post"
        let refreshButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.toggleFavorite))
        refreshButton.tintColor = .white
        refreshButton.image = UIImage(systemName: "star") // Add star filled or not based on object attribute
        
        self.navigationItem.rightBarButtonItem = refreshButton
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    @objc private func toggleFavorite() {
        
    }


}
