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
    
    var potentialTimes = [PotentialTime]()
    var location = MKMapItem()
    var groupID: String!
    
    var eventID: String!
    
    weak var allEventsDelegate: UserEventsTableViewController?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBAction func createEventButton(_ sender: UIButton) {
        print("inside programtic text bit")
       saveEvent()
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
        if segue.identifier == "shareEventSegue" {
            let destination = segue.destination as! EventShareViewController
            destination.eventDelegate = self
        }

    }
    
    func addDateRange(newDateRange: [Date]) -> Bool {
        newDateRange.forEach { date in
            potentialTimes.append(PotentialTime(time: date, votes: nil))
        }
        return true
    }
    
    func addLocation(newLocation: MKMapItem) -> Bool {
        location = newLocation
        return true
    }
    
    func addGroup(newGroup: String) -> Bool {
        groupID = newGroup
        return true
    }
    
    func saveEvent() {
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
        
        let potentialLocations = PotentialLocation(location: location, votes: nil)
        let event = Event(name: name,
                          descriptor: eventDescription,
                          groupId: groupID,
                          times: potentialTimes,
                          locations: potentialLocations)
        
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        do {
            ref = try database.collection("events").addDocument(from: event)
            print("event should be in firestore")
            eventID = ref?.documentID
            
        } catch let error {
            print("Error writing event to Firestore: \(error)")
        }
        
        if let a = event.times {
            for time in a {
                do {
                    try database.collection("events").document(ref!.documentID).collection("potential times").addDocument(from: time)
                    
                } catch let error {
                    print("Couldn't add times to the event:", error )
                }
               
            }
        }
        allEventsDelegate?.tableView.reloadData()
//        allEventsDelegate?.tableView.reloadSections([allEventsDelegate?.SECTION_EVENT], with: .automatic)
    }
    
    
    
    
    
   
}
