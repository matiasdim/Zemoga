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
    
    let reuseIdentifier = "ReuseIdentifier"
    var data: [String] = ["asasdsd asd mljkwe jljnsdf jdjnq cjkwc ac qjn q ckjq", "Asdasd"]//[]
    
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
        
        self.pullData { [weak self](_) in
            self?.tableView.reloadData()
        }
        self.emptyView.alpha = self.data.isEmpty ? 1 : 0.0
        
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        // Update table data based on Favorites ON/OFF
    }
    
    @IBAction func deleteAllPressed(_ sender: Any) {
        self.data.removeAll()
        self.toggleEmptyView(hide: false)
    }
    
    @objc private func refresh() {
        self.pullData { [weak self]  (_) in
            self?.tableView.reloadData()
        }
    }
    
    private func pullData(callback: @escaping (Any?) -> ()) { // Change anny for theneeded object model
        if NetworkManager.isInternetReachable() {
//            KRProgressHUD.show(withMessage: "Getting posts...")
            callback(nil)
            //Gmake callto get data
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
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Opendetail view sending the object selected
        self.navigationController?.pushViewController(DetailViewController(), animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier) as? CustomTableViewCell {
            if indexPath.row < 1 { // Change to 20
                cell.unreadImageView.isHidden = false
            } 
            cell.titleLabel.text = self.data[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.data.remove(at: indexPath.row)
            self.toggleEmptyView(hide: !self.data.isEmpty)
            tableView.reloadData()
        }
    }
    
}
