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
    private var datesRange: [Date]?
    private var firstDate: Date?
    private var lastDate: Date?
    var event: Event?
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBAction func confirmAvailability(_ sender: Any) {
//        let potentialTime = event?.times.first{$0.time == date}
//        if potentialTime?.votes ?? 0 > 0 {
//            return otherVotedDateColour
//        }
        /*
        if datesRange != nil {
            for date in datesRange! {
                let potentialTime = event?.times.first{$0.time == date}
                let votes = potentialTime?.votes ?? 0
                print("votes increase by 1 at date: ", date)
                
                let washingtonRef = database.collection("events").document(event?.id ?? "").updateData([
                    "times"
                ]) //maybe i should do error handling with this unwrap, check that event has id? but it really must have one

                // Set the "capital" field of the city 'DC'
                washingtonRef.updateData([
                    "votes": votes + 1
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            }
            
            // To update age and favorite color:
            db.collection("users").document("frank").updateData([
                "age": 13,
                "favorites.color": "Red"
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
        }
 */

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
            firstDate = date
            datesRange = [firstDate!]
            return
        }
        
        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                return
            }
            
            let range = datesRange(from: firstDate!, to: date)
            
            lastDate = range.last
            
            for date in range {
                calendar.select(date)
            }
            
            datesRange = range
            return
        }
        
        // both are selected:
        if firstDate != nil && lastDate != nil {
            for date in calendar.selectedDates {
                calendar.deselect(date)
            }
            
            lastDate = nil
            firstDate = nil
            
            datesRange = []
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:
        
        //        // NOTE: the is a REDUANDENT CODE:
        //        if firstDate != nil && lastDate != nil {
        //            for d in calendar.selectedDates {
        //                calendar.deselect(d)
        //            }
        //
        //            lastDate = nil
        //            firstDate = nil
        //
        //            datesRange = []
        //            print("datesRange contains: \(datesRange!)")
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        print("call fillDefaultColorFor", date)
        let otherVotedDateColour = UIColor(named: "Light Pink")
        
        let potentialTime = event?.times?.first{$0.time == date}
        if potentialTime?.votes ?? 0 > 0 {
            return otherVotedDateColour
        }
        
        if Calendar.current.isDateInToday(date) {
            return UIColor(named: "AccentColor")
        }
        return UIColor(named: "Background Colour")
    }
//    self.presentDatesArray = ["2016-04-03",
//            "2016-04-06",
//            "2016-04-12",
//            "2016-04-25"];
//
//            self.absentDatesArray = ["2016-04-10",
//                "2016-04-18",
//                "2016-04-15",
//                "2016-04-16"];

//
//        func calendar(calendar: FSCalendar!, appearance: FSCalendarAppearance!, titleDefaultColorForDate date: NSDate!) -> UIColor!
//        {
//            let dateString: String = calendar.stringFromDate(date, format: "yyyy-MM-dd")
//
//
//            if presentDatesArray.containsObject(dateString)
//            {
//                return UIColor.greenColor()
//            }
//            else if absentDatesArray.containsObject(dateString)
//            {
//                return UIColor.redColor()
//            }
//            else
//            {
//                return nil
//            }
//        }



    
}



