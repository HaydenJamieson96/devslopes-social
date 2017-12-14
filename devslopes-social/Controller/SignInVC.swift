//
//  ViewController.swift
//  devslopes-social
//
//  Created by TheAppExperts on 12/12/17.
//  Copyright © 2017 TheAppExperts. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("HAYDEN: UNABLE TO AUTHENTICATE WITH FB - \(String(describing: error))")
            } else if result?.isCancelled == true{
                print("HAYDEN: User cancelled fb auth")
            } else {
                print("HAYDEN: Successfully auth with FB")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("HAYDEN: UNable to auth with Firebase - \(String(describing: error))")
            } else {
                print("HAYDEN: Sucessfully authenticated with Firebase")
            }
        }
    }
    
}

