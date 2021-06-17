//
//  CreateGroupViewController.swift
//  hey m8
//
//  Created by Christina Li on 24/5/21.
//

import UIKit
import Firebase
import OSLog

class CreateGroupViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    let SECTION_USER = 0
    let SECTION_CREATE = 1
    
    let CELL_USER = "memberCell"
//    let CELL_CREATE = "createButtonCell"
    @IBOutlet weak var membersTable: UITableView!
    var database: Firestore!
    var docRef:DocumentReference!
    
    @IBOutlet weak var currentMemberNamesLabel: UILabel!
    var temporaryGroupID: Int!

    var groupDelegate: UserGroupsTableViewController?
    var currentMembers = [User]()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBAction func createGroupButton(_ sender: Any) {
        createGroup()
    }

    func createGroup() {
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

        //Get member IDs
        var ids = [String]()
        for member in currentMembers {
            ids.append(member.id)
        }
        
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = database.collection("groups").addDocument(data: [
            "name": name,
            "description": groupDescription,
            "members": ids
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        let newGroup = Group(name: name, groupID: ref!.documentID, members: ids)
        
        groupDelegate?.addGroup(newGroup: newGroup)
        //move back to groups screen
        navigationController?.popViewController(animated: true)
    }
    //Consider future guard for group with no member? Or perhaps group must default have the person who created the group

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Background Colour")

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
        
//        let currentMembersDisplayNamesText = currentMembersDisplayNamesArray.joined(separator: ", ")
        
        //update the label on main thread
//        DispatchQueue.main.async(execute: {
//            self.currentMemberNamesLabel.text = "Current Members: " + currentMembersDisplayNamesText
//           })
        
        //Refresh the members table so we can see it
        membersTable.reloadSections([SECTION_USER], with: .automatic)
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_USER:
                return currentMembers.count
            case SECTION_CREATE:
                return 1
            default:
                return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_USER {
            let userCell = tableView.dequeueReusableCell(withIdentifier: CELL_USER, for: indexPath)
            let user = currentMembers[indexPath.row]
            
            userCell.textLabel?.text = user.displayName
            userCell.detailTextLabel?.text = user.email
            return userCell
        }

//        let createCell = tableView.dequeueReusableCell(withIdentifier: CELL_CREATE, for: indexPath)
//        createCell.textLabel?.text = "Create Group"
//        createCell.textLabel?.textAlignment = .center
//        createCell.textLabel?.textColor = UIColor(named: "Background Colour")
    
//        return createCell
        return UITableViewCell() //should not happen
    }

    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     if indexPath.section == SECTION_USER {
         return true
     }
     // Return false if you do not want the specified item to be editable.
     return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete && indexPath.section == SECTION_USER {
            print("trying to delete a member from group")
            currentMembers.remove(at: indexPath.row)
            membersTable.deleteRows(at: [indexPath], with: .fade)
            membersTable.reloadSections([SECTION_USER], with: .automatic)
         }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_USER {
            
//            if let memberDelegate = memberDelegate {
//                if memberDelegate.addMember(newMember: currentMembers[indexPath.row]) {
//                    //After we've added a user, we don't want them to show up anymore
//                    allUsers.remove(at: indexPath.row)
//                    navigationController?.popViewController(animated: true)
//                    return
//                }
//                else {
//                    displayMessagecli240(title: "Group is full", message: "Unable to add more members to group")
//                }
//            }
            
        }
        if indexPath.section == SECTION_CREATE {
            createGroup()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
  

}


