//
//  NavigationView.swift
//  knockknock
//
//  Created by Nicole Hinckley on 11/3/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import UIKit

class NavigationView : UIView {
    
    @IBOutlet weak var blurNavigationBar : UIVisualEffectView!
    @IBOutlet weak var unblurredNavigationBar : UIView!
    @IBOutlet weak var blurTabBar : UIVisualEffectView!
    @IBOutlet weak var unblurredTabBar : UIView!
    
    @IBOutlet weak var blurredFriendButton : UIButton!
    @IBOutlet weak var blurredBubbleButton : UIButton!
    @IBOutlet weak var blurredCollectionButton : UIButton!
    
    @IBOutlet weak var unblurredFriendButton : UIButton!
    @IBOutlet weak var unblurredBubbleButton : UIButton!
    @IBOutlet weak var unblurredCollectionButton : UIButton!
    
    func animateIconColor(offset: CGFloat) {
  
    
    }
    
    override func awakeFromNib() {
        unblurredTabBar.alpha = 0
    }
    
    func animateToFriends(offset : CGFloat) {
        blurNavigationBar.alpha = 1 - offset
        unblurredNavigationBar.alpha = 1 - blurNavigationBar.alpha
        blurTabBar.alpha = 1 - offset
        unblurredTabBar.alpha = 1 - blurNavigationBar.alpha
        if unblurredFriendButton.imageView?.image != #imageLiteral(resourceName: "friendIcon_friend_selected")  {
            unblurredFriendButton.setImage(#imageLiteral(resourceName: "friendIcon_friend_selected"), for: .normal)
        }
        if unblurredCollectionButton.imageView?.image != #imageLiteral(resourceName: "collectionIcon") {
            unblurredCollectionButton.setImage(#imageLiteral(resourceName: "collectionIcon") , for: .normal)
        }
    }
    func animateToCollection(offset : CGFloat) {
        blurNavigationBar.alpha = 1 - offset
        unblurredNavigationBar.alpha = 1 - blurNavigationBar.alpha
        blurTabBar.alpha = 1 - offset
        
        if unblurredFriendButton.imageView?.image != #imageLiteral(resourceName: "friendIcon_collection_unselected")  {
            unblurredFriendButton.setImage(#imageLiteral(resourceName: "friendIcon_collection_unselected"), for: .normal)
        }
        if unblurredCollectionButton.imageView?.image != #imageLiteral(resourceName: "collectionIcon_collection_selected") {
            unblurredCollectionButton.setImage(#imageLiteral(resourceName: "collectionIcon_collection_selected") , for: .normal)
        }
    }
    
    func animate(to percent: CGFloat) {
       
        let offset = abs(percent)
        // Pulling left to friends
        if percent < 0 {
            animateToFriends(offset: offset)
        } else  if percent > 0 {
            animateToCollection(offset: offset)
        // pulling right to collection
        } else {
            
            unblurredTabBar.alpha = 0
            unblurredNavigationBar.alpha = 0
        }
        layoutIfNeeded()
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

