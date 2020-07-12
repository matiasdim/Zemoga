//
//  DetailViewController.swift
//  ZemogaTest
//
//  Created by Matías Gil Echavarría on 7/10/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit
import KRProgressHUD

protocol PostManagmentDelegate: AnyObject {
    func favoriteButtonPressed(for post: Post)
}

class DetailViewController: UIViewController {
    var refreshButton: UIBarButtonItem!
    var post: Post
    var user: User? {
        didSet {
            self.userNameLabel.text = self.user?.name
            self.userEmailLabel.text = self.user?.email
            self.userPhoneLabel.text = self.user?.phone
            self.userWebsiteLabel.text = self.user?.website
        }
    }
    var commentsArray: [Comment] = []
    weak var delegate: PostManagmentDelegate?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userWebsiteLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    init(post: Post, delegate: PostManagmentDelegate) {
        self.post = post
        self.delegate = delegate
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
        
        self.descriptionLabel.text = self.post.body
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        // Load user info
        self.pullUsers()
        
    }
    
    private func pullUsers() {
        if NetworkManager.isInternetReachable() {
            KRProgressHUD.show(withMessage: "Getting users...")
            User.getUser(userId: self.post.userId) { [weak self] (user) in
                KRProgressHUD.dismiss()
                if let user = user {
                    self?.user = user
                }
                self?.pullPostComments()
            }
        } else {
            let alert = UIAlertController(title: "Alert!", message: "No internet connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    private func pullPostComments() {
        if NetworkManager.isInternetReachable() {
            KRProgressHUD.show(withMessage: "Getting post comments..")
            Comment.getComments(for: self.post) { [weak self] (comments) in
                if let comments = comments {
                    self?.commentsArray = comments
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        } else {
            let alert = UIAlertController(title: "Alert!", message: "No internet connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
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

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier"){
            cell.backgroundColor = .systemGray6
            cell.textLabel?.textColor = .gray
            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .none
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
            cell.textLabel?.text = self.commentsArray[indexPath.row].body
            return cell
        }
        return UITableViewCell()
    }
}
