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
        static let friends = "friends"
    }
    
    func createUser(withData data: [String : Any], completion : @escaping ErrorCompletion){
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        db.collection(Collections.users).document(currentUserUID).setData(data) { (error) in
            if let err = error {
                completion(err)
            } else {
                completion(nil)
            }
            }
        }
    
    
    func fetchFriends(completion : @escaping (_ friends : [Friend]?, _ error : Error?) -> ()) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(nil, nil)
            return
        }
        let ref = db.collection(Collections.users).document(currentUserUID).collection(Collections.friends)
    
        ref.getDocuments { (querySnapshot, error) in
            if let err = error {
                completion(nil, err)
            } else {
                var friendArray = [Friend]()
                for document in querySnapshot!.documents {
                    let friend = Friend()
                    friend.uid = document.documentID
                    friend.status = document.data()["status"] as! String
                    friendArray.append(friend)
                }
                completion(friendArray,nil)
            }
            
        }
    }
    
    func getFriendInfo(for friends : [Friend], completion: @escaping (_ friends : [Friend]?) -> ()) {
        
        var friendsArray = [Friend]()
        let dispatchGroup = DispatchGroup()
        for friend in friends {
           dispatchGroup.enter()
            print("Entering")
            let ref = db.collection(Collections.users).document(friend.uid)
            ref.getDocument { (snapshot, error) in
                dispatchGroup.leave()
                print("Leaving")
                if let err = error {
                    return 
                } else {
                    guard let friendInfo = snapshot?.data() else { return }
                    guard let username = friendInfo["username"] as? String else { return }
                    friend.username = username
                    friendsArray.append(friend)
                }
            }
        }
        dispatchGroup.notify(queue: .main, execute: {
            print("Done")
            completion(friendsArray)
        })
    }
}
