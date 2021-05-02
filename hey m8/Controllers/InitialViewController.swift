//
//  ViewController.swift
//  hey m8
//
//  Created by Christina Li on 30/4/21.
//

//sign in code with lots of help from
// https://medium.com/swlh/google-sign-in-integration-in-ios-90cdd5cb5967

//For other UI and other sign in apart from Google
//https://firebase.google.com/docs/auth/ios/firebaseui


import UIKit
import GoogleSignIn
import Firebase

class InitialViewController: UIViewController {

    @IBOutlet weak var googleSignInButton: GIDSignInButton!

//   var signInButton: UIButton!
      var signOutButton: UIButton!
      var greetingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Add greeting label
       greetingLabel = UILabel()
       greetingLabel.text = "Log in or sign up to hey m8"
       greetingLabel.textAlignment = .center
//       greetingLabel.backgroundColor = .tertiarySystemFill
       view.addSubview(greetingLabel)
       greetingLabel.translatesAutoresizingMaskIntoConstraints = false
       greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       greetingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
       greetingLabel.heightAnchor.constraint(equalToConstant: 54).isActive = true
       greetingLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
       
        if self.traitCollection.userInterfaceStyle == .dark {
            // User Interface is Dark
            googleSignInButton.colorScheme = GIDSignInButtonColorScheme.dark
        } else {
            googleSignInButton.colorScheme = GIDSignInButtonColorScheme.light
        }
//       googleSignInButton.style = GIDSignInButtonStyle.iconOnly
//
        /*
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
 */
        
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
        
       // Let GIDSignIn know that this view controller is presenter of the sign-in sheet
       GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        // Register notification to update screen after user successfully signed in
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userDidSignInGoogle(_:)),
                                               name: .signInGoogleCompleted,
                                               object: nil)
        
        // Update screen base on sign-in/sign-out status (when screen is shown)
        updateScreen()
    }

    // MARK:- Notification
    @objc private func userDidSignInGoogle(_ notification: Notification) {
        // Update screen after user successfully signed in
//        updateScreen()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabViewController = storyboard.instantiateViewController(identifier: "MainTabViewController")
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabViewController)
    }
    
    @objc func signOutButtonTapped(_ sender: UIButton) {
        // Sign out from Google
        GIDSignIn.sharedInstance()?.signOut()
        
        // Sign out from Firebase
        do {
            try Auth.auth().signOut()
            
            // Update screen after user successfully signed out
            updateScreen()
        } catch let error as NSError {
            print ("Error signing out from Firebase: %@", error)
        }
    }
    
    private func updateScreen() {
        
        if let user = GIDSignIn.sharedInstance()?.currentUser {
            // User signed in
            
            // Show greeting message
            greetingLabel.text = "Hey \(user.profile.givenName!)! ✌️"
            
            // Hide sign in button
            googleSignInButton.isHidden = true
            
            // Show sign out button
           signOutButton.isHidden = false
            
        } else {
            // User signed out
            
            // Show sign in message
             greetingLabel.text = "Log in or sign up to hey m8"
             
             // Show sign in button
             googleSignInButton.isHidden = false
             
             // Hide sign out button
             signOutButton.isHidden = true
        }
    }
}

