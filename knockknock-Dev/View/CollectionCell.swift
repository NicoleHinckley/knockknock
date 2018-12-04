//
//  CollectionsCell.swift
//  knockknock
//
//  Created by Nicole Hinckley on 11/4/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import UIKit

class CollectionCell : UICollectionViewCell {
    
    
    
    var collection : Collection! {
        didSet {
            configure(withCollection: collection)
        }
    }
    
    @IBOutlet weak var participationCountLabel : UILabel!
    @IBOutlet weak var thumnail : UIImageView!
    @IBOutlet weak var notificationDot : UIImageView!
    @IBOutlet weak var lockedImage : UIImageView!
    @IBOutlet weak var selectedCollectionView : SelectedCellHighlightView!
    
    func configure(withCollection collection : Collection) {

        self.participationCountLabel.isHidden = collection.locked
        self.notificationDot.isHidden = collection.locked
        self.participationCountLabel.text = String(collection.posts.count)
        self.thumnail.sd_setImage(with: URL(string: collection.thumbnailURL))
        self.notificationDot.isHidden = collection.hasSeenSinceUnlocked
        self.lockedImage.isHidden = !collection.locked
        toggleHighlight()
    }
    
    func toggleHighlight() {
        if collection.isHighlighted {
            selectedCollectionView.isHidden = false
        } else {
            selectedCollectionView.isHidden = true
        }
    }
}

class PostCell : UICollectionViewCell {
    
    @IBOutlet weak var postImage : UIImageView!
    @IBOutlet weak var selectedCollectionView : UIView!
    var post : Post! {
        didSet {
            configure(withPost: post)
        }
    }
      func configure(withPost collection : Post) {
       
        self.postImage.sd_setImage(with:  URL(string: post.imageURL)) { (image, error, cache, url) in
            // TODO: - handle
            self.post.image = image
        }
        toggleHighlight()
    }
    
    func toggleHighlight() {
        if post.isHighlighted {
            selectedCollectionView.isHidden = false
        } else {
            selectedCollectionView.isHidden = true
        }
    }
}
