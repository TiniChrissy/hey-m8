//
//  AddMemberSearchTableViewController.swift
//  hey m8
//
//  Created by Christina Li on 23/5/21.
//

import UIKit
import FirebaseFirestore

class AddMemberSearchTableViewController: UITableViewController, UISearchResultsUpdating {
    let SECTION_USER = 0
    let SECTION_INFO = 1
    
    let CELL_USER = "userCell"
    let CELL_INFO = "infoCell"
    
    var allUsers:[User] = []
    
    weak var memberDelegate: CreateGroupViewController?
    
    var filteredUsers:[User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        createDefaultMeals()
        
        getAllUsers()
        filteredUsers = allUsers
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search All Users"
        navigationItem.searchController = searchController
        
        // This view controller decides how the search controller is presented
        definesPresentationContext = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_USER:
                return filteredUsers.count
            case SECTION_INFO:
                return 1
            default:
                return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_USER {
            let userCell = tableView.dequeueReusableCell(withIdentifier: CELL_USER, for: indexPath)
            let user = filteredUsers[indexPath.row]
            
            
            userCell.textLabel?.text = user.displayName
//            userCell.detailTextLabel?.text = meal.instructions
            return userCell
        }

        let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath) //as! MealCountTableViewCell
        
        infoCell.textLabel?.text = "\(filteredUsers.count) users in the database"
    
        return infoCell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     if indexPath.section == SECTION_USER {
         return true
     }
     // Return false if you do not want the specified item to be editable.
     return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete && indexPath.section == SECTION_USER {
             // Delete the row from the data source
             tableView.performBatchUpdates({
                if let index = self.allUsers.firstIndex(of: filteredUsers[indexPath.row]) {
                    self.allUsers.remove(at: index)
                }
                 self.filteredUsers.remove(at: indexPath.row)
                 self.tableView.deleteRows(at: [indexPath], with: .fade)
                 self.tableView.reloadSections([SECTION_INFO], with: .automatic)
             }, completion: nil)
         }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let memberDelegate = memberDelegate {
            if memberDelegate.addMember(newMember: filteredUsers[indexPath.row]) {
                navigationController?.popViewController(animated: false)
                return
            }
            else {
                displayMessagecli240(title: "Group is full", message: "Unable to add more members to group")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func createDefaultMeals() {
//        let potato = IngredientMeasurement(name: "Milk", quantity: "A lot")
//
//        let milk = IngredientMeasurement(name: "Milk", quantity: "A little")
//        let sugar = IngredientMeasurement(name: "Sugar", quantity: "A lot")
//
//        allMeals.append(Meal(name: "Potato", instructions: "Put the potato in the oven. Take the potato out of the oven.", ingredients: [potato]))
//
//        allMeals.append(Meal(name: "Milkshake", instructions: "Mix it all up.", ingredients: [milk, sugar]))
//    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }

        if searchText.count > 0 {
            filteredUsers = allUsers.filter({ (user: User) -> Bool in
                return (user.displayName.lowercased().contains(searchText))
            })
        } else{
            filteredUsers = allUsers}
        tableView.reloadData()

    }
    
//    func addMeal(_ newHero: Meal) -> Bool {
//        tableView.performBatchUpdates({
//            // Safe because search can't be active when Add button is tapped.
//            allMeals.append(newHero)
//            filteredMeals.append(newHero)
//
//            tableView.insertRows(at: [IndexPath(row: filteredUsers.count-1, section: SECTION_USER)],with: .automatic)
//            tableView.reloadSections([SECTION_INFO], with: .automatic)}, completion: nil)
//        return true
//    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "createOrEditMealSegue" {
//            let destination = segue.destination as! CreateOrEditMealTableViewController
//            destination.mealDelegate = self}
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
    func getAllUsers() {
        //Local emulator settings
        //COMMENT THIS SECTION OUT FOR REAL CONNECTION
        let settings = Firestore.firestore().settings
        settings.host = "localhost:8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        
        // Save user data into firestore
        let database = Firestore.firestore()
        database.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let user = User(id: document.documentID, displayName: document.data()["displayName"] as! String)
                    self.allUsers.append(user)
//                    do {
//                        if let user = try document.data(as: User.self) {
//                            print(user.displayName)
//                        }
//                    } catch let error as NSError {
//                        print("error: \(error.localizedDescription)")
//                    }
                    
                }
            }
        }
        

        

    }


}
