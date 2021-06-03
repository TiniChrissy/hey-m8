//
//  CreateEventViewController.swift
//  hey m8
//
//  Created by Christina Li on 21/5/21.
//

import UIKit
import Firebase
import OSLog

class CreateEventViewController: UIViewController {
    
    var database: Firestore!
    var docRef:DocumentReference!
    
    var groupID: Int!
    
//    let name = "eventName"
//    let eventDescription = "eventDescription"
    var currentDateRange = [Date]()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBAction func createEventButton(_ sender: UIButton) {
        guard let name = nameTextField.text, name.isEmpty==false else{
            displayMessagecli240(title: "Error", message: "Please enter a name")
            return
        }
        guard let eventDescription = descriptionTextField.text, name.isEmpty==false else{
            displayMessagecli240(title: "Error", message: "Please enter a description")
            return
        }
        
        if currentDateRange.isEmpty {
            displayMessagecli240(title: "Error", message: "Please select a date range")
            return
        }
        
//        let dataToSave: [String:Any] = [name: nameTextField, eventDescription: descriptionTextField]
       
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = database.collection("events").addDocument(data: [
            "name": name,
            "description": eventDescription,
            
//            currentDateRange.forEach({ Date in
//                ref.collection("dateRange").document("time").setData([
//                    "name": "Los Angeles",
//                    "state": "CA",
//                    "country": "USA"
//                ]) { err in
//                    if let err = err {
//                        print("Error writing document: \(err)")
//                    } else {
//                        print("Document successfully written!")
//                    }
//                }
//            })

        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        //move to QR code screen push view cnotroller?
//        navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
    }
    
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocationSegue" {
//            let destination = segue.destination as! AddLocationViewController
//            destination.event = self
        }
        if segue.identifier == "addDateRangeSegue" {
            let destination = segue.destination as! AddDateRange
            destination.dateRangeDelegate = self
            print("set self as delegate")
            
        }
    }
    
    func addDateRange(newDateRange: [Date]) -> Bool {
        currentDateRange = newDateRange
//        print(currentDateRange)
        return true
    }
    
   
}
