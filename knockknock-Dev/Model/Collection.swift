//
//  Collection.swift
//  knockknock-Dev
//
//  Created by Nicole Hinckley on 12/3/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import UIKit

protocol DictionaryInitializable {
    init?(dictionary : [String : Any])
}

class Collection: DictionaryInitializable  {
    var thumbnailURL          = ""
    var timeInitiated         = 0.0
    var participantCount      = 0
    var hasSeenSinceUnlocked  = false
    var posts : [Post]        = []
    var posterUID             = ""
    var uid                   = ""
    var thumbnail : UIImage?  = nil
    var isHighlighted        = false
    var locked               = false
    
    required init?(dictionary: [String : Any]) {
        
    }
}

class Post: DictionaryInitializable {
    required init?(dictionary: [String : Any]) {
        
    }
    
    var timePosted : TimeInterval = 0.0
    var uid : String = ""
    var posterUID : String = ""
    var imageURL : String = ""
    var likes : Int = 0
    var isLiked = false
    var isHighlighted = false
    var image : UIImage? = nil
}
