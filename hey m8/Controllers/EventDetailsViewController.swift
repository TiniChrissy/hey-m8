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
    var selectedDates = [PotentialTime]()
    private var firstDate: Date?
    private var lastDate: Date?
    var event: Event!
    
    let SECTION_DATE = 0
    let SECTION_COUNT = 1
    let CELL_DATE = "dateCell"
    let CELL_COUNT = "dateCountCell"
    
    @IBAction func confirmAvailability(_ sender: Any) {
        if (tableView.indexPathsForSelectedRows == nil) {
            displayMessagecli240(title: "Invalid Date Range", message: "Please vote for at least one date")
        }
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
                            
                            self.selectedDates.forEach({ date in
                                if date.time == potentialTime.time {
                                    potentialTimesCollection.document(ID).updateData([
                                        "vote": FieldValue.increment(Int64(1))
                                    ])
                                    
                                    if let i = self.votedDatesRange.firstIndex(where: {$0.time == date.time}) {
                                        if self.votedDatesRange[i].votes == nil {
                                            self.votedDatesRange[i].votes = 1
                                        } else {
                                            self.votedDatesRange[i].votes! += 1
                                        }
                                    }
                                    self.tableView.reloadSections([self.SECTION_DATE], with: .automatic)
                                }
                            })
                            
                        } else {
                            // A nil value was successfully initialized from the DocumentSnapshot,
                            // or the DocumentSnapshot was nil.
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        // A `potentialTime` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding city: \(error)")
                    }
                }
            }
            self.selectedDates.removeAll()
//            self.dateRangeDelegate
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
            if success {
                self.tableView.reloadSections([self.SECTION_DATE], with: .automatic)
                self.votedDatesRange.forEach({ potentialTime in
                    print("date", potentialTime.time)
                    print("votes", potentialTime.votes)
                })
                
                self.tableView.reloadSections([self.SECTION_COUNT], with: .automatic)
            } else {
                // placeholder
            }
        })
        tableView?.allowsMultipleSelection = true
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_DATE:
            return votedDatesRange.count
        case SECTION_COUNT:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_DATE {
            let timeCell = tableView.dequeueReusableCell(withIdentifier: CELL_DATE, for: indexPath)
            timeCell.backgroundColor = UIColor(named: "Background Colour")
            let time = votedDatesRange[indexPath.row]
            
            let formatter1 = DateFormatter()
            formatter1.dateStyle = .short
            
            timeCell.textLabel?.text = formatter1.string(from: time.time)
            
            print("this should not be zero", time.votes)
            if time.votes == nil {
                time.votes = 0
            }
            
            timeCell.detailTextLabel?.text = "Number of votes: " + String(format: "%d", time.votes ?? "0")
            
            //Multiple seleciton
            if let selectedPaths = tableView.indexPathsForSelectedRows as? [NSIndexPath] {
                let selected = selectedPaths.filter(){ $0 as IndexPath == indexPath }
                if selected.count > 0 {
                    timeCell.accessoryType = .checkmark
                } else {
                    timeCell.accessoryType = .none
                }
            }
            
            return timeCell
        }
        
        if indexPath.section == SECTION_COUNT {
            let countCell = tableView.dequeueReusableCell(withIdentifier: CELL_COUNT, for: indexPath)
            countCell.backgroundColor = UIColor(named: "Background Colour")
            //            countCell.textLabel?.text = String(votedDatesRange.count) + " available dates for you to choose from"
            
            if votedDatesRange.count == 0 {
                countCell.textLabel?.text = "No available dates for you to choose from"
            } else if (votedDatesRange.count > 0) {
                countCell.textLabel?.text = String(votedDatesRange.count) + " available dates for you to choose from"
            }
            
            countCell.textLabel?.numberOfLines=0
            countCell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            countCell.textLabel?.textColor = .secondaryLabel
            countCell.selectionStyle = .none
            return countCell
        }
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
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_DATE {
            if let cell = tableView.cellForRow(at: indexPath) {
                self.selectedDates.append(votedDatesRange[indexPath.row])
            }
        }
        if indexPath.section == SECTION_COUNT {
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_DATE {
            if let cell = tableView.cellForRow(at: indexPath) {
                let deselectedData = self.votedDatesRange[indexPath.row]
                if let i = self.selectedDates.firstIndex(where: {$0.time == deselectedData.time}) {
                    selectedDates.remove(at: i)
                }
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
                    print("document", document.data())
                    let result = Result {
                        try document.data(as: PotentialTime.self)
                        
                    }
                    switch result {
                    case .success(let potentialTime):
                        if let potentialTime = potentialTime {
                            let a = document.data()
                            let ID = document.documentID
                            potentialTime.votes = a["vote"] as? Int
                            self.votedDatesRange.append(potentialTime)
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
        
    }
}
