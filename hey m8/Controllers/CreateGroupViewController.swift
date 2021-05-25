//
//  CreateGroupViewController.swift
//  hey m8
//
//  Created by Christina Li on 24/5/21.
//

import UIKit
import Firebase
import OSLog

class CreateGroupViewController: UIViewController {
    
    var database: Firestore!
    var docRef:DocumentReference!
    
    @IBOutlet weak var currentMemberNamesLabel: UILabel!
    var temporaryGroupID: Int!
    
//    let name = "eventName"
//    let eventDescription = "eventDescription"
//
    var groupDelegate: Any?
    var currentMembers = [User]()
    
//    var temporaryGroup = Group()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBAction func createGroupButton(_ sender: UIButton) {
        guard let name = nameTextField.text, name.isEmpty==false else{
            displayMessagecli240(title: "Error", message: "Please enter a name for your group")
            return
        }
        guard let groupDescription = descriptionTextField.text, name.isEmpty==false else{
//        guard let ageText = descriptionTextField.text, let age = Int(ageText) else{
            // Age could not be established. Print an error and exit
            displayMessagecli240(title: "Error", message: "Please enter a description for your group")
            return
        }
        
//        let dataToSave: [String:Any] = [name: nameTextField, eventDescription: descriptionTextField]
        
//        let newPerson = Person(name: name, age: age)
        
//        displayMessagecli240(title:"Greetings", message: newPerson.greeting())
        
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = database.collection("groups").addDocument(data: [
            "name": name,
            "description": groupDescription,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        //move to QR code screen
    }

    //Consider future guard for group with no member? Or perhaps group must default have the person who created the group

    override func viewDidLoad() {
        super.viewDidLoad()

//      Production settings
//        let settings = FirestoreSettings()
//        Firestore.firestore().settings = settings

        //Emulator settings
        let settings = Firestore.firestore().settings
        settings.host = "localhost:8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        
        //Connect to database
        database = Firestore.firestore()
    }

    // MARK: - Navigation
    
//     In a storyboard-based application, you will often want to do a little preparation before navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMemberSegue" {
            let destination = segue.destination as! AddMemberSearchTableViewController
            destination.memberDelegate = self}
//         Get the new view controller using segue.destination.
//         Pass the selected object to the new view controller.
    }
    
    //Do I really need to add the whole user or can I just add the user ID?
    // For now the whole user I guess
    func addMember(newMember: User) -> Bool {
        currentMembers.append(newMember)
        var currentMembersDisplayNamesArray = [String]()
     
        for member in currentMembers {
            currentMembersDisplayNamesArray.append(member.displayName)
        }
        
        let currentMembersDisplayNamesText = currentMembersDisplayNamesArray.joined(separator: ", ")
        
        //update the label on main thread
        DispatchQueue.main.async(execute: {
            self.currentMemberNamesLabel.text = "Current Members: " + currentMembersDisplayNamesText
           })
        return true
    }

    func createTemporaryGroup() {
//        temporaryGroup = Group(name: "temp", groupID: temporaryGroupID, members: [String]())
    }
}


