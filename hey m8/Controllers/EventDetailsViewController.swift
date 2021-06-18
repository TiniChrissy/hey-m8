//
//  EventDetailsViewController.swift
//  hey m8
//
//  Created by Christina Li on 5/6/21.
//
//https://stackoverflow.com/questions/30401439/how-could-i-create-a-function-with-a-completion-handler-in-swift

import UIKit
import FirebaseFirestore

class EventDetailsViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    var database: Firestore!
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var dateRangeDelegate: CreateEventViewController?
    var votedDatesRange = [PotentialDate]()
    var selectedDates = [PotentialDate]()
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
        let potentialDatesCollection = eventDocument.collection("potential times")
        
        potentialDatesCollection.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let result = Result {
                        try document.data(as: PotentialDate.self)
                    }
                    switch result {
                    case .success(let potentialDate):
                        if let potentialDate = potentialDate {
                            let ID = document.documentID
                            
                            //For each date the user has selected
                            self.selectedDates.forEach({ date in
                                // check it against each potential date
                                if date.time == potentialDate.time {
                                    // If it matches, increment the vote on firestore
                                    potentialDatesCollection.document(ID).updateData([
                                        "vote": FieldValue.increment(Int64(1))
                                    ])
                                    
                                    //Update the vote locally as well
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
                        // A `potentialDate` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding city: \(error)")
                    }
                }
            }
            // Here is before the end of the completion. i.e, here is where to write code for after network calls have run
            self.selectedDates.removeAll()
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
        
        // After data is retrieved, update the table
        getPotentialDates(completionHandler: { (success) -> Void in
            if success {
                self.tableView.reloadSections([self.SECTION_DATE], with: .automatic)
                self.tableView.reloadSections([self.SECTION_COUNT], with: .automatic)
            } else {
                // placeholder
            }
        })
        tableView.allowsMultipleSelection = true
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
            
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            
            timeCell.textLabel?.text = formatter.string(from: time.time)

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
    func getPotentialDates(completionHandler: @escaping CompletionHandler) {
        let eventDocument = database.collection("events").document(event.id?.documentID ?? "")
        let potentialDatesCollection = eventDocument.collection("potential times")
        
        potentialDatesCollection.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let result = Result {
                        try document.data(as: PotentialDate.self)
                        
                    }
                    switch result {
                    case .success(let potentialDate):
                        //If the type is correct
                        if let potentialDate = potentialDate {
                            let data = document.data()
                            //Have to manually set this for some reason, the decoding doesn't seem to work correctly
                            potentialDate.votes = data["vote"] as? Int
                            
                            self.votedDatesRange.append(potentialDate)
                        } else {
                            // A nil value was successfully initialized from the DocumentSnapshot,
                            // or the DocumentSnapshot was nil.
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        // A `PotentialDate` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding city: \(error)")
                    }
                }
            }
            let flag = true // true if function succeed,false otherwise
            completionHandler(flag)
            
        }
        
    }
}
