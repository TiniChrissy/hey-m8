//
//  EventDetailsViewController.swift
//  hey m8
//
//  Created by Christina Li on 5/6/21.
//

import UIKit
import FirebaseFirestore

class EventDetailsViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    var database: Firestore!
    
    @IBOutlet weak var tableView: UITableView!
    weak var dateRangeDelegate: CreateEventViewController?
    var votedDatesRange = [PotentialTime]()
    private var currentUserDatesRange: [Date]?
    private var firstDate: Date?
    private var lastDate: Date?
    var event: Event!
    
    let SECTION_DATE = 0
    let SECTION_COUNT = 1
    let CELL_DATE = "dateCell"
    let CELL_COUNT = "dateCountCell"
    
    @IBAction func confirmAvailability(_ sender: Any) {
        let eventDocument = database.collection("events").document(event.id?.documentID ?? "")
        let potentialTimesCollection = eventDocument.collection("potential times")
        
        potentialTimesCollection.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let result = Result {
                        try document.data(as: PotentialTime.self)
                    }
                    switch result {
                    case .success(let potentialTime):
                        if let potentialTime = potentialTime {
                            let ID = document.documentID
                            
                            //Cast vote if in selected date range
                            self.currentUserDatesRange?.forEach({ date in
//                                let potentialTime = self.event?.times?.first{$0.time == date}
                                if date == potentialTime.time {
                                    potentialTimesCollection.document(ID).updateData([
                                        "vote": FieldValue.increment(Int64(1))
                                    ])
                                }
                            })
                        } else {
                            // A nil value was successfully initialized from the DocumentSnapshot,
                            // or the DocumentSnapshot was nil.
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        // A `City` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding city: \(error)")
                    }
                }
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Background Colour")
        
        //Emulator settings
        let settings = Firestore.firestore().settings
        settings.host = "localhost:8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        
        //Connect to database
        database = Firestore.firestore()
 
        getPotentialTimes(completionHandler: { (success) -> Void in
            // When download completes,control flow goes here.
            if success {
                self.tableView.reloadSections([self.SECTION_DATE], with: .automatic)
            } else {
                // download fail
            }
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_DATE:
                print("number of rows", votedDatesRange.count)
                return votedDatesRange.count
                
            case SECTION_COUNT:
                return 1
            default:
                return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_DATE {
            print("in date section")
            let timeCell = tableView.dequeueReusableCell(withIdentifier: CELL_DATE, for: indexPath)
            let time = votedDatesRange[indexPath.row]
            
            let formatter1 = DateFormatter()
            formatter1.dateStyle = .short
            
            timeCell.textLabel?.text = formatter1.string(from: time.time)
            let str1 = "\(time.votes)"
            timeCell.detailTextLabel?.text = str1
//                String(time.votes ?? "0")
//                String(format: "%d", time.votes ?? "0")
            return timeCell
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
     if indexPath.section == SECTION_DATE {
         return true
     }
     // Return false if you do not want the specified item to be editable.
     return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete && indexPath.section == SECTION_DATE {
//            print("trying to delete a member from group")
//            currentMembers.remove(at: indexPath.row)
//            membersTable.deleteRows(at: [indexPath], with: .fade)
//            membersTable.reloadSections([SECTION_USER], with: .automatic)
         }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_DATE {
            
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
        if indexPath.section == SECTION_COUNT {
//            createGroup()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    typealias CompletionHandler = (_ success:Bool) -> Void
    func getPotentialTimes(completionHandler: @escaping CompletionHandler) {
        let eventDocument = database.collection("events").document(event.id?.documentID ?? "")
        let potentialTimesCollection = eventDocument.collection("potential times")
        
        potentialTimesCollection.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let result = Result {
                        try document.data(as: PotentialTime.self)
                    }
                    switch result {
                    case .success(let potentialTime):
                        if let potentialTime = potentialTime {
                            let ID = document.documentID
                            self.votedDatesRange.append(potentialTime)
//                            print("potentialTime inside",potentialTime)
                        } else {
                            // A nil value was successfully initialized from the DocumentSnapshot,
                            // or the DocumentSnapshot was nil.
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        // A `City` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding city: \(error)")
                    }
                }
            }
            //Here is where I believe the completion handler should go. It is exactly at this point that we are sure the async code has run.
//            print("here is where the completion handler should be i think and therefore votedDatesRange works", self.votedDatesRange)
            let flag = true // true if download succeed,false otherwise
            completionHandler(flag)
            
        }
//        print("entire function ended votedDatesRange", self.votedDatesRange)
        
       
        
        print("should also be empty", self.votedDatesRange)

    }


}
    
    
