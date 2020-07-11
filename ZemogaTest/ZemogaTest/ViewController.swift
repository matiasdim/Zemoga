//
//  MainViewController.swift
//  ZemogaTest
//
//  Created by Matías Gil Echavarría on 7/10/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit
import KRProgressHUD

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var emptyView: UIView!
    
    private let reuseIdentifier = "ReuseIdentifier"
    private var posts: [Post] = []
    private var favoritePosts: [Post] = []
    private var isShowingFavorites = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Posts"
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refresh))
        refreshButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = refreshButton
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.segmentedControl.tintColor = .systemGreen
        self.segmentedControl.backgroundColor = .systemGreen
        self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemGreen], for: .selected)
    
        self.tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: self.reuseIdentifier)
        
        self.emptyView.alpha = self.posts.isEmpty ? 1 : 0.0
        self.pullPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        self.isShowingFavorites = sender.selectedSegmentIndex == 1 ? true : false
        self.tableView.reloadData()
    }
    
    @IBAction func deleteAllPressed(_ sender: Any) {
        self.posts.removeAll()
        self.favoritePosts.removeAll()
        self.segmentedControl.selectedSegmentIndex = 0
        self.isShowingFavorites = false
        self.toggleEmptyView(hide: false)
    }
    
    @objc private func refresh() {
        self.pullPosts()
    }
    
    private func pullPosts() {
        if NetworkManager.isInternetReachable() {
            KRProgressHUD.show(withMessage: "Getting posts...")
            Post.getProducts { [weak self] (posts) in
                KRProgressHUD.dismiss()
                guard let weakSelf = self else {
                    return
                }
                weakSelf.segmentedControl.selectedSegmentIndex = 0
                weakSelf.isShowingFavorites = false
                weakSelf.posts = posts
                weakSelf.favoritePosts = []
                // WORKAROUND: To keep track of unread and favorite directly related to each post, I manually add thos values toeach Post object
                // Not ideal, but it could be improved for example adding FAVORITED and UNREAD attributes to the API. Also
                for (index, _) in weakSelf.posts.enumerated() {
                    self?.posts[index].favorite = false
                    self?.posts[index].unread = (index < 21)
                }
                weakSelf.toggleEmptyView(hide: !posts.isEmpty)
                weakSelf.tableView.reloadData()
            }
        } else {
            let alert = UIAlertController(title: "Alert!", message: "No internet connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    private func toggleEmptyView(hide: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.emptyView.alpha = hide ? 0.0 : 1
        }
    }

}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            return self.posts.count
        case 1:
            return self.favoritePosts.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.posts[indexPath.row].unread = false
        tableView.reloadData()
        self.navigationController?.pushViewController(DetailViewController(post: self.posts[indexPath.row], delegate: self), animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier) as? CustomTableViewCell {
            let post = self.isShowingFavorites ? self.favoritePosts[indexPath.row] : self.posts[indexPath.row]
            // TO avoid missmatched of favorite and unread values because of the cell reuse, those values are attached to the object and not to the cell
            if let unread = post.unread {
                cell.unreadImageView.isHidden = self.isShowingFavorites || !unread
                if let favorite = post.favorite {
                    cell.favoriteImageView.isHidden = unread || !favorite
                } else {
                    cell.favoriteImageView.isHidden = false
                }
            } else {
                cell.unreadImageView.isHidden = true
            }
            cell.titleLabel.text = post.title
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.posts.remove(at: indexPath.row)
            self.toggleEmptyView(hide: !self.posts.isEmpty)
            tableView.reloadData()
        }
    }
    
}

extension MainViewController: PostManagmentDelegate {
    func favoriteButtonPressed(for post: Post) {
        if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
            self.posts[index].favorite?.toggle()
            //Add or remove the post from the favorited posts array
            if let favorite = self.posts[index].favorite, favorite {
                self.favoritePosts.append(self.posts[index])
            } else if let index = self.favoritePosts.firstIndex(where: { $0.id == post.id }) {
                self.favoritePosts.remove(at: index)
            }
        }
    }
}
