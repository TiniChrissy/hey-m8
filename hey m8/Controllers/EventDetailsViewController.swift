//
//  EventDetailsViewController.swift
//  hey m8
//
//  Created by Christina Li on 5/6/21.
//

import UIKit
import FSCalendar
import FirebaseFirestore

class EventDetailsViewController: UIViewController, FSCalendarDelegate, FSCalendarDelegateAppearance {
    var database: Firestore!
    
    weak var dateRangeDelegate: CreateEventViewController?
//    private var votedDatesRange: [PotentialTime]?
//    var votedDatesRange:[PotentialTime] = []
//    var cards = [Car]()
    var votedDatesRange = [PotentialTime]()
    private var currentUserDatesRange: [Date]?
    private var firstDate: Date?
    private var lastDate: Date?
    var event: Event!
    
    @IBOutlet weak var calendar: FSCalendar!
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
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        calendar.backgroundColor = UIColor(named: "Background Colour")
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
        
        //Emulator settings
        let settings = Firestore.firestore().settings
        settings.host = "localhost:8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        
        //Connect to database
        database = Firestore.firestore()
        getPotentialTimes()
//        do {
//            sleep(5)
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
           // Code you want to be delayed
            print("voted dates range", self.votedDatesRange)
        }
        
        
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        var start = from
        var end = to
        
        if from > to {
            //            return [Date]()
            start = to
            end = from
        }
        
        var tempDate = start
        var array = [tempDate]
        
        while tempDate < end {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        // nothing selected:
        if firstDate == nil {
            print("first")
            firstDate = date
            currentUserDatesRange = [firstDate!]
            return
        }
        
        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            print("second")
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                currentUserDatesRange = [firstDate!]
                return
            }
            
            let range = datesRange(from: firstDate!, to: date)
            lastDate = range.last
            
            for date in range {
                calendar.select(date)
            }
            
            currentUserDatesRange = range
            return
        }
        
        // both are selected:
        if firstDate != nil && lastDate != nil {
            print("third")
            for date in calendar.selectedDates {
                calendar.deselect(date)
            }
            
            lastDate = nil
            firstDate = nil
            
            currentUserDatesRange = []
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        var color = UIColor(named: "Background Colour")
//        var test = UIColor()
        // Need to get the colour from this but for some reason
        
        let otherVotedDateColour = UIColor(named: "Light pink")
        for potentialTime in self.votedDatesRange {
            if potentialTime.time == date {
                color = otherVotedDateColour
//                let insideColor = otherVotedDateColour
//                test = otherVotedDateColour!
//                        print("tried to set colour of voted date")
                        print("color", color)

                return color!
            }
        }

        print("color just after getpotentialTimes", color)

       
//        print("r", r)
        if Calendar.current.isDateInToday(date) {
            return UIColor(named: "AccentColor")
        }
//        print("color before return", color)
        return color
    }
    
    typealias CompletionHandler = (_ success:Bool) -> UIColor
    
    func getPotentialTimes(){
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
            
//            let flag = true // true if download succeed,false otherwise
//            completionHandler(flag)

        }
//        print("should also be empty", self.votedDatesRange)

    }


}



