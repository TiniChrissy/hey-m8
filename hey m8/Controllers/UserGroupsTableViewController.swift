//
//  GroupsTableViewController.swift
//  hey m8
//
//  Created by Christina Li on 23/5/21.
//

import UIKit
import FirebaseFirestore

class UserGroupsTableViewController: UITableViewController {
    var database: Firestore!

    let SECTION_GROUP = 0;
    let SECTION_INFO = 1;
    let CELL_GROUP = "groupCell";
    let CELL_INFO = "infoCell";
    
    var allGroups: [Group] = [] //allGroups? inclues for users apart from this one.. ??maybe not necessary if i'm just directly adding it to firebase anwyays
    var userGroups: [Group] = [] //filteredGroups?
    
//    weak var memberDelegate: addMemberDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        Production settings
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
        
//        tableView.performBatchUpdates(getAllGroups(), completion: nil)

//        tableView.beginUpdates()
//        tableView.insertRows(at: [IndexPath(row: userGroups.count - 1, section: 0)],
//                             with: .automatic)
//        tableView.endUpdates()
        getAllGroups()
        tableView.reloadSections([SECTION_GROUP], with: .automatic)
        
        

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_GROUP:
                return userGroups.count
            case SECTION_INFO:
                return 1
            default:
                return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_GROUP {
            let groupCell =
                tableView.dequeueReusableCell(withIdentifier: CELL_GROUP, for: indexPath)
            let group = userGroups[indexPath.row]
            
            print("about to do the group name")
            groupCell.textLabel?.text = group.name
            
            //Get member id and its respective displayName
            for member in group.members {
                //need error checking here for if the member doesn't exist otherwise app will crash
                let docRef = database.collection("users").document(member)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
//                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        
                        let a = document.data()?["displayName"] as! String
                        
                        if member != group.members[0] {
                            groupCell.detailTextLabel?.text?.append(", ")
                        }
                        groupCell.detailTextLabel?.text?.append(a)
//                        print("Document data: \(dataDescription)")
                    } else {
                        print("Document does not exist")
                    }
                }

            }
//
            return groupCell
        }
        
        if indexPath.section == SECTION_INFO {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
            
            cell.textLabel?.textColor = .secondaryLabel
            cell.selectionStyle = .none
            
            if userGroups.count == 1 {
                cell.textLabel?.text = "\(userGroups.count) group"
            } else if (userGroups.count > 0) {
                cell.textLabel?.text = "\(userGroups.count) groups"
            }
            else {
                cell.textLabel?.text = "You don't have any groups. Click + to create a new group"
            }
            return cell
        }
     
        return UITableViewCell()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_GROUP {
            return true
        }
        return false
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_GROUP {
            tableView.performBatchUpdates({
                // Delete the row from the data source
                self.userGroups.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadSections([SECTION_INFO], with: .automatic)
            }, completion: nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createGroupSegue" {
            let destination = segue.destination as! CreateGroupViewController
            destination.groupDelegate = self
        }
    }
    
    //Add to current table and display
    func addGroup(newGroup: Group) -> Bool {
        userGroups.append(newGroup)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: userGroups.count - 1, section: 0)],
                             with: .automatic)
        tableView.endUpdates()
        tableView.reloadSections([SECTION_INFO], with: .automatic)
        return true
    }
    
    func getAllGroups() -> Void { //from firestore
        let database = Firestore.firestore()
        database.collection("groups").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
                    
                    let groupName = document.data()["name"] as! String
                    let groupId = document.documentID
                    let groupMembers = document.data()["members"] as? Array<String> ?? [""]
                    
                    let group = Group(name: groupName, groupID: groupId, members: groupMembers)
                    self.addGroup(newGroup: group)
                }
            }
        }
        
    }

}

