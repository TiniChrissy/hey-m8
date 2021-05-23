//
//  GroupsTableViewController.swift
//  hey m8
//
//  Created by Christina Li on 23/5/21.
//

import UIKit

class UserGroupsTableViewController: UITableViewController {

    let SECTION_GROUP = 0;
    let SECTION_INFO = 1;
    let CELL_GROUP = "groupCell";
    let CELL_INFO = "infoCell";
    
    var userGroups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                as! GroupTableViewCell
            let group = userGroups[indexPath.row]
            
            groupCell.groupNameLabel.text = group.name
            groupCell.groupMembersLabel.text = group.members.joined(separator: ", ")
            
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
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "allHeroesSegue" {
//            let destination = segue.destination as! AllHeroesTableViewController
//            destination.superHeroDelegate = self
//        }
//    }
    
    // MARK: - AddSuperHero Delegate
//    func addSuperHero(newHero: SuperHero) -> Bool {
//        if userGroups.count >= 6 {
//            return false
//        }
//
//        tableView.performBatchUpdates({
//            currentParty.append(newHero)
//            tableView.insertRows(at: [IndexPath(row: userGroups.count - 1,
//                                                section: SECTION_GROUP)], with: .automatic)
//            tableView.reloadSections([SECTION_INFO], with: .automatic)
//        }, completion: nil)
//        return true
//    }
}