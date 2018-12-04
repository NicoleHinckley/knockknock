//
//  FriendsVC.swift
//  knockknock
//
//  Created by Nicole Hinckley on 11/4/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import UIKit


protocol FriendListInteractionDelegate {
    func added(friend : Friend, atRow : Int)
    func declined(friend : Friend, atRow : Int)
}

class FriendsVC : UIViewController {
    
    var friends = [Friend]()
    private let refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshFriendsTable), for: .valueChanged)
        fetchFriends()
    }
    
    @objc func refreshFriendsTable() {
        fetchFriends()
    }
    
    func fetchFriends(){
        FIRFireStoreService.shared.fetchFriends { (friends, error) in
            if let err = error {
                self.alert(message: err.localizedDescription)
            } else {
                guard let friends = friends else { return }
        
                FIRFireStoreService.shared.getFriendInfo(for: friends, completion: { (friends) in
                    guard let friends = friends else { return }
                    self.friends = friends
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                })
            }
        }
      }
    }

extension FriendsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        let friend = friends[indexPath.row]
        cell.friend = friend
        cell.friendListDelegate = self
        cell.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension FriendsVC : FriendListInteractionDelegate {
    func added(friend: Friend, atRow row: Int) {
        //friend.added = true
        tableView.reloadData()
    }
    
    func declined(friend: Friend, atRow row: Int) {
       friends.remove(at: row)
       tableView.reloadData()
    }
}
