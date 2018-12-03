//
//  CreateAccountVC.swift
//  knockknock-Dev
//
//  Created by Nicole Hinckley on 12/3/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    // MARK: -  Outlets
    @IBOutlet weak var usernameTF : UITextField!
    @IBOutlet weak var emailTF : UITextField!
    @IBOutlet weak var passwordTF : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
      
    }
    
    @IBAction func createAccount(){
        guard let username = usernameTF.text, usernameTF.text != "", let password = passwordTF.text, passwordTF.text != "",  let email = emailTF.text, emailTF.text != "" else {
            self.alert(message: "Make sure to fill out all of the fields", title: "Oops")
            return
        }
  
        FIRAuthService.shared.createUserWith(email: email, password: password) { (user, error) in
            guard error == nil  else {
                self.alert(message: error?.localizedDescription ?? "Unknown error creating an account", title: "Error")
                return
            }
            guard user != nil else {
                self.alert(message: "Unknown error creating an account", title: "Error")
                return
            }
            
            let userDict = ["username" : username]
            FIRFireStoreService.shared.createUser(withData: userDict, completion: { (error) in
                if error != nil {
                    self.alert(message: "Unknown error saving your username, try again later from your profile", title: "Error")
                }
            })
            self.performSegue(withIdentifier: "toHome", sender: nil)
        }
    }
}
