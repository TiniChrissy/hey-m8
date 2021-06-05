//
//  CreateEventViewController.swift
//  hey m8
//
//  Created by Christina Li on 21/5/21.
//

import UIKit
import Firebase
import OSLog
import MapKit

class CreateEventViewController: UIViewController {
    
    var database: Firestore!
    var docRef:DocumentReference!
    

    
//    let name = "eventName"
//    let eventDescription = "eventDescription"
//    var currentDateRange = [Date]()
//    var currentLocation = MKMapItem()
    
    var potentialTimes = [PotentialTime]()
    var location = MKMapItem()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    var groupID: String!
    
    @IBAction func createEventButton(_ sender: UIButton) {
        guard let name = nameTextField.text, name.isEmpty==false else{
            displayMessagecli240(title: "Error", message: "Please enter a name")
            return
        }
        guard let eventDescription = descriptionTextField.text, name.isEmpty==false else{
            displayMessagecli240(title: "Error", message: "Please enter a description")
            return
        }
        guard groupID != nil else{
            displayMessagecli240(title: "Error", message: "Please select a group")
            return
        }
        
        if potentialTimes.isEmpty {
            displayMessagecli240(title: "Error", message: "Please select a date range")
            return
        }
        //..I don't think I actually need to do any encoding?
//        do {
//          let event = Event(name: name,
//                            descriptor: eventDescription,
//                            groupId: groupID,
//                            times: potentialTimes,
//                            locations: potentialLocations)
//          let encoder = JSONEncoder()
//          let data = try encoder.encode(event)
//        }
//        catch {
//          print("Error when trying to encode book: \(error)")
//        }
        
//        let dataToSave: [String:Any] = [name: nameTextField, eventDescription: descriptionTextField]
       
        let potentialLocations = PotentialLocation(location: location, votes: nil)
        let event = Event(name: name,
                                    descriptor: eventDescription,
                                    groupId: groupID,
                                    times: potentialTimes,
                                    locations: potentialLocations)

     
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        do {
            try database.collection("events").addDocument(from: event)
            print("event should be in firestore")
        } catch let error {
            print("Error writing event to Firestore: \(error)")
        }
//        ref = database.collection("events").addDocument(from: event)
        
        
        // Add a new document with a generated ID
//        var ref: DocumentReference? = nil
//        ref = database.collection("events").addDocument(data: [
//            "name": name,
//            "description": eventDescription,
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
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
            let destination = segue.destination as! AddLocationViewController
            destination.locationDelegate = self
        }
        if segue.identifier == "addDateRangeSegue" {
            let destination = segue.destination as! AddDateRangeViewController
            destination.dateRangeDelegate = self
        }
        if segue.identifier == "linkToGroupSegue" {
            let destination = segue.destination as! UserGroupsTableViewController
            destination.eventDelegate = self
        }
    }
    
    func addDateRange(newDateRange: [Date]) -> Bool {
//        currentDateRange = newDateRange
        
        newDateRange.forEach { date in
            potentialTimes.append(PotentialTime(time: date, votes: nil))
        }
        return true
    }
    
    func addLocation(newLocation: MKMapItem) -> Bool {
//        currentLocation = newLocation
//        print(currentLocation.name ?? "",  currentLocation.placemark.title ?? "", "look")
        location = newLocation
        return true
    }
    
    func addGroup(newGroup: String) -> Bool {
        groupID = newGroup
        return true
    }
   
}
