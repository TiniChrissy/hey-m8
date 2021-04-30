//
//  ViewController.swift
//  hey m8
//
//  Created by Christina Li on 30/4/21.
//

import UIKit
import GoogleSignIn

class InitialViewController: UIViewController {

//    @IBOutlet weak var signInButton: GIDSignInButton!
    
   var signInButton: UIButton!
      var signOutButton: UIButton!
      var greetingLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Add greeting label
       greetingLabel = UILabel()
       greetingLabel.text = "Welcome to hey m8"
       greetingLabel.textAlignment = .center
//       greetingLabel.backgroundColor = .tertiarySystemFill
       view.addSubview(greetingLabel)
       greetingLabel.translatesAutoresizingMaskIntoConstraints = false
       greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       greetingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
       greetingLabel.heightAnchor.constraint(equalToConstant: 54).isActive = true
       greetingLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
       
        
       // Add sign-in button
       signInButton = UIButton()
       signInButton.layer.cornerRadius = 10.0
       signInButton.setTitle("Sign in with Google", for: .normal)
       signInButton.setTitleColor(.white, for: .normal)
       signInButton.backgroundColor = .systemRed
//       signInButton.addTarget(self, action: #selector(signInButtonTapped(_:)), for: .touchUpInside)
       view.addSubview(signInButton)
       signInButton.translatesAutoresizingMaskIntoConstraints = false
       signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       signInButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
       signInButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
       
 
        /*
       // Add sign-out button
       signOutButton = UIButton()
       signOutButton.layer.cornerRadius = 10.0
       signOutButton.setTitle("Sign Out 👋", for: .normal)
       signOutButton.setTitleColor(.label, for: .normal)
       signOutButton.backgroundColor = .systemFill
       signOutButton.addTarget(self, action: #selector(signOutButtonTapped(_:)), for: .touchUpInside)
       view.addSubview(signOutButton)
       signOutButton.translatesAutoresizingMaskIntoConstraints = false
       signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
       signOutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
       signOutButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
       
       // Sign-out button is hidden by default
       signOutButton.isHidden = true

        */
       // Let GIDSignIn know that this view controller is presenter of the sign-in sheet
       GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()

    }


}

