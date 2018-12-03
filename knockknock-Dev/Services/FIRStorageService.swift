//
//  FIRStorageService.swift
//  knockknock-Dev
//
//  Created by Nicole Hinckley on 12/3/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import UIKit
import Firebase



class FIRStorageService {
    private init (){}
    static let shared = FIRStorageService()
    let storage = Storage.storage()
 
    
    
    func profileImagesRef() -> StorageReference {
        return storage.reference().child("profileImages")
    }
    
    func addProfileImage(forUID uid : String, withImageData data: Data,  completion : @escaping (_ downloadURL : URL?, _ error : Error?) -> ()){
      
        
        // Data in memory

        // Create a reference to the file you want to upload
        let ref = profileImagesRef().child(uid)
        
        // Upload the file to the path "images/rivers.jpg"
        let _ = ref.putData(data, metadata: nil) { (metadata, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            // You can also access to download URL after upload.
            ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(nil, error)
                    return
                }
                completion(downloadURL, nil)
            }
        }
        
    }
 
    
}
