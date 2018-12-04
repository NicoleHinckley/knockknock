//
//  Friend.swift
//  knockknock-Dev
//
//  Created by Nicole Hinckley on 12/3/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import Foundation

class Friend  {
    var username : String = ""
    var status : String = ""
    var uid : String = ""
    var added = false
    
     init?(dictionary: [String : Any]) {
        guard let username = dictionary["username"] as? String,
              let uid = dictionary["uid"] as? String,
              let status = dictionary["status"] as? String else { return nil }
        
        self.username = username
        self.uid = uid
        self.status = status
        
    }
    
    init(username : String = "", added : Bool = false, uid : String = "123") {
        self.username = username
        self.added = added
        self.uid = uid
    }
}
