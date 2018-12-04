//
//  FriendCell.swift
//  knockknock
//
//  Created by Nicole Hinckley on 11/4/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import UIKit


class FriendCell : UITableViewCell {
    
    var friendListDelegate : FriendListInteractionDelegate?
    
    var friend : Friend! {
        didSet {
            configure(withFriend: friend )
        }
    }
    
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var addButton : UIButton!
    @IBOutlet weak var declineButton : UIButton!
    
    func configure(withFriend friend : Friend) {
        self.nameLabel.text = friend.username
        self.addButton.isHidden = friend.added
        self.declineButton.isHidden = friend.added
    }
    
    @IBAction func addFriend() {
        friendListDelegate?.added(friend: friend, atRow: self.tag)
    }
    
    @IBAction func declineFriend() {
        friendListDelegate?.declined(friend: friend, atRow: self.tag)
    }

}

