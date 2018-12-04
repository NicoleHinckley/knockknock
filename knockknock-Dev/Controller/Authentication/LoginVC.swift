//
//  ViewController.swift
//  knockknock-Dev
//
//  Created by Nicole Hinckley on 12/3/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
 
    @IBOutlet weak var emailTF : UITextField!
    @IBOutlet weak var passwordTF : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuthService.shared.checkForCurrentUser { (user) in
            if user != nil {
            self.performSegue(withIdentifier: "toHome", sender: nil)
            }
        }
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
         guard let imageData = #imageLiteral(resourceName: "jonsnow").pngData() else { return }
        FIRStorageService.shared.addProfileImage(forUID: "123", withImageData: imageData) { (url, error) in
            guard let url = url else {
                self.alert(message: error?.localizedDescription ?? "Unknown error uploading image", title : "Error")
                return
            }
            print(url)
        }
    }

    @IBAction func signIn(){
        guard let password = passwordTF.text, passwordTF.text != "", let email = emailTF.text, emailTF.text != "" else {
            self.alert(message: "Make sure to fill out all of the fields", title: "Oops")
            return 
        }
        FIRAuthService.shared.signInWith(email: email, password: password) { (user, error) in
            guard error == nil  else {
                self.alert(message: error?.localizedDescription ?? "Unknown error creating an account", title: "Error")
                return
            }
            guard user != nil else {
                self.alert(message: "Unknown error creating an account", title: "Error")
                return
            }
            
            self.performSegue(withIdentifier: "toHome", sender: nil)
        }
    }

}

