//
//  FIRAuthService.swift
//  knockknock-Dev
//
//  Created by Nicole Hinckley on 12/3/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import Foundation
import Firebase

typealias AuthCompletion =  (_ user: User? , _ error : Error?) -> ()
class FIRAuthService {
    private init () {}
    static let shared = FIRAuthService()
    
    func createUserWith(email : String, password : String, completion : @escaping AuthCompletion) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                completion(nil, error)
            } else {
                let user = authResult?.user
                completion(user, nil)
            }
        }
    }
    
    func signInWith(email : String, password : String , completion : @escaping AuthCompletion) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                completion(nil, error)
            } else {
                let user = authResult?.user
                completion(user, nil)
            }
        }
    }
    
    func signOut(completion : @escaping (_ error : Error?)->()){
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let signOutError {
            completion(signOutError)
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func checkForCurrentUser(completion : @escaping (_ user : User?) -> ()) {
        completion(Auth.auth().currentUser)
    }
}
