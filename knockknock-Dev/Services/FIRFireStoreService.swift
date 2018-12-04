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
        static let collections = "collections"
    }
    
    
    // MARK: -  CREATE
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
    
    func createCollection(withUID uid : String, withData data: [String : Any], completion : @escaping (_ collection : Collection?, _ error : Error?) -> ()) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        db.collection(Collections.collections).document(uid).setData(data) { (error) in
            if let err = error {
                completion(nil, err)
            } else {
                let collection = Collection(dictionary: data)
                let ref = self.db.collection(Collections.users).document(currentUserUID).collection(Collections.collections).document(uid)
                ref.setData([:])
                completion(collection, nil)
            }
        }
    }
    
    // MARK: -  READ
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
    
    
    func observeUsersJoinedCollections(completion: @escaping (_ collections : [Collection]?, _ error : Error?) -> () ) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        let ref = db.collection(Collections.users).document(currentUserUID).collection(Collections.collections)
        
        ref.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
            } else {
                var collectionsArray = [Collection]()
                let dispatchGroup = DispatchGroup()
                for change in querySnapshot!.documentChanges {
                    
                    switch change.type {
                    case .added :
                        dispatchGroup.enter()
                        let document = change.document
                     
                        let ref = self.db.collection(Collections.collections).document(document.documentID)
                        ref.getDocument(completion: { (snapshot, error) in
                            dispatchGroup.leave()
                            if let _ = error {
                               return
                            } else {
                                guard let dataDict = snapshot?.data() else { return }
                                guard let collection = Collection(dictionary: dataDict) else { return }
                                collectionsArray.append(collection)
                            }
                        })
                        
                    case .removed : print("Removed")
                    case .modified : print("Modified")
                    }
                }
                dispatchGroup.notify(queue: .main, execute: {
                    print("Done")
                    completion(collectionsArray, nil)
                })
            
            }
            }
        }
  
    
    func observeJoinableCollections(completion : @escaping (_ collections : [Collection]?, _ error : Error?) -> ()) {
    
         let now = NSDate().timeIntervalSince1970
         let fourMinsAgo = now - (60 * 4)
      
         let ref = db.collection(Collections.collections).whereField("timeInitiated", isGreaterThan: fourMinsAgo)
         ref.addSnapshotListener { (querySnapshot, error) in
            
            if let err = error {
                completion(nil, err)
            } else {
            
           var collectionsArray = [Collection]()
            for change in querySnapshot!.documentChanges {
                switch change.type {
                case .added :
                    let document = change.document
                    let dataDict = document.data()
                    guard let collection = Collection(dictionary: dataDict) else { return }
                    collectionsArray.append(collection)
                case .removed : print("Removed")
                case .modified : print("Modified")
                }
            }
                completion(collectionsArray, nil)
        }
    }
    }
    func getFriendInfo(for friends : [Friend], completion: @escaping (_ friends : [Friend]?) -> ()) {
        
        var friendsArray = [Friend]()
        let dispatchGroup = DispatchGroup()
        for friend in friends {
           dispatchGroup.enter()
            let ref = db.collection(Collections.users).document(friend.uid)
            ref.getDocument { (snapshot, error) in
                dispatchGroup.leave()
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
            completion(friendsArray)
        })
    }
    
    func updateBubbleLocation(uid : String, withPosition position: CGPoint){
        db.collection(Collections.collections).document(uid).updateData([
            "xPos": position.x,
            "yPos": position.y
        ]) { err in
            if let err = err {
              
            } else {
            
            }
        }
    }
}
