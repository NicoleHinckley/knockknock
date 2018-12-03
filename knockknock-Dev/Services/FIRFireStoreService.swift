//
//  FIRFireStoreService.swift
//  knockknock-Dev
//
//  Created by Nicole Hinckley on 12/3/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import Firebase

class FIRFireStoreService {
    
    typealias ErrorCompletion = (_ error : Error?) -> ()
    private init (){}
    static let shared = FIRFireStoreService()
    
     let db = Firestore.firestore()
    
    struct Collections {
        static let users = "users"
    }
    
    func createUser(withData data: [String : Any], completion : @escaping ErrorCompletion){
        db.collection(Collections.users).addDocument(data: data) { err in
            if let err = err {
               completion(err)
            } else {
               completion(nil)
            }
        }
    }
}
