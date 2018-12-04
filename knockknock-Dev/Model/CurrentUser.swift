//
//  CurrentUser.swift
//  knockknock-Dev
//
//  Created by Nicole Hinckley on 12/3/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import Foundation

class CurrentUser {
    private init(){}
    static let shared = CurrentUser()
    
    var name : String = ""
    var uid : String = ""
    
    var collections = [Collection]()
    var friends = [Friend]()
}
