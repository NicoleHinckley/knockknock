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
    var xPos : Double
    var yPos : Double
    var thumbnailURL  : String
    var timeInitiated  : TimeInterval
    var participantCount      = 1
    var hasSeenSinceUnlocked  = false
    var posts : [Post]        = []
    var posterUID  : String
    var uid      : String
    var thumbnail : UIImage?  = nil
    var isHighlighted        = false
    var locked               = false
    
    required init?(dictionary: [String : Any]) {
        guard let thumbnailURL = dictionary["thumbnailURL"] as? String,
              let timeInitiated = dictionary["timeInitiated"] as? TimeInterval,
              let posterUID = dictionary["posterUID"] as? String,
              let uid = dictionary["uid"] as? String,
              let xPos = dictionary["xPos"] as? Double,
              let yPos = dictionary["yPos"] as? Double else { return nil }
        
        self.xPos = xPos
        self.yPos = yPos
        self.thumbnailURL = thumbnailURL
        self.timeInitiated = timeInitiated
        self.posterUID = posterUID
        self.uid = uid
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
