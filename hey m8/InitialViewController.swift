//
//  ViewController.swift
//  hey m8
//
//  Created by Christina Li on 30/4/21.
//

import UIKit
import GoogleSignIn

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()

        // ...

    }


}

