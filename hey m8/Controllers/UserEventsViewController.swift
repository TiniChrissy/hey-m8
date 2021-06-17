//
//  EventsViewController.swift
//  hey m8
//
//  Created by Christina Li on 2/5/21.
//

import UIKit
import FirebaseFirestore

class UserEventsTableViewController: UITableViewController {
    var database: Firestore!

    let SECTION_EVENT = 0;
    let SECTION_INFO = 1;
    let CELL_GROUP = "eventCell";
    let CELL_INFO = "infoCell";
    
    var allEvents: [Event] = [] //allEvents? inclues for users apart from this one.. ??maybe not necessary if i'm just directly adding it to firebase anwyays
    var userEvents: [Event] = [] //filteredEvents?
    
    var eventToBeSent: Event?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Background Colour")
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

        getAllEvents()
        tableView.reloadSections([SECTION_EVENT], with: .automatic)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_EVENT:
                return userEvents.count
            case SECTION_INFO:
                return 1
            default:
                return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_EVENT {
            let eventCell =
                tableView.dequeueReusableCell(withIdentifier: CELL_GROUP, for: indexPath)
            let event = userEvents[indexPath.row]

            eventCell.textLabel?.text = event.name
            eventCell.backgroundColor = UIColor(named: "Background Colour")
            

            return eventCell
        }
        
        if indexPath.section == SECTION_INFO {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
            
            cell.textLabel?.textColor = .secondaryLabel
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "Background Colour")
            
            if userEvents.count == 1 {
                cell.textLabel?.text = "\(userEvents.count) event"
            } else if (userEvents.count > 0) {
                cell.textLabel?.text = "\(userEvents.count) events"
            }
            else {
                cell.textLabel?.text = "You don't have any events. Click + to create a new event"
                cell.textLabel?.numberOfLines=0
                cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            }
            return cell
        }
     
        return UITableViewCell()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_EVENT {
            return true
        }
        return false
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_EVENT {
            tableView.performBatchUpdates({
                // Delete the row from the data source
                self.userEvents.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadSections([SECTION_INFO], with: .automatic)
            }, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_EVENT {
            self.eventToBeSent = userEvents[indexPath.row]
            self.performSegue(withIdentifier: "eventDetailsSegue", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetailsSegue" {
            let destination = segue.destination as! EventDetailsViewController
            destination.event = eventToBeSent
        }
    }
    
    //Add to current table and display
    func addEvent(newEvent: Event) -> Bool {
        userEvents.append(newEvent)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: userEvents.count - 1, section: 0)],
                             with: .automatic)
        tableView.endUpdates()
        tableView.reloadSections([SECTION_INFO], with: .automatic)
        return true
    }
    
    func getAllEvents() -> Void { //from firestore
        let database = Firestore.firestore()
        database.collection("events").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let event = try document.data(as: Event.self)
                        self.addEvent(newEvent: event!)
                    }
                    catch {
                        print(error)
                    }
                    //                    print("\(document.documentID) => \(document.data())")
                    //
                    //                    let eventName = document.data()["name"] as! String
                    //                    let eventId = document.documentID
                    //                    let eventMembers = document.data()["members"] as? Array<String> ?? [""]
                    //
                    //                    let event = Event(name: eventName, descriptor: nil, groupId: <#T##Int#>, times: <#T##Array<PotentialTime>#>, locations: <#T##Array<PotentialLocation>#>)
                    //                    let event = Event(name: eventName, eventID: eventId)
                    //                    self.addEvent(newEvent: event)
                }
            }
        }
        
    }

}

