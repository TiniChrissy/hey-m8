//
//  DateSelectionViewController.swift
//  hey m8
//
//  Created by Christina Li on 11/5/21.
//
//https://stackoverflow.com/questions/49856370/how-to-select-range-fscalendar-in-swift

import UIKit
import FSCalendar

class AddDateRangeViewController: UIViewController, FSCalendarDelegate {
    @IBOutlet weak var calendar: FSCalendar!
    @IBAction func saveDateRange(_ sender: Any) {
        if let dateRangeDelegate = dateRangeDelegate {
            print("indaterangedelegate")
            if dateRangeDelegate.addDateRange(newDateRange: datesRange ?? [Date]()) {
                navigationController?.popViewController(animated: true)
                return
            }
            else {
                displayMessagecli240(title: "Invalid Date Range", message: "Please try another selection of dates")
            }
        }
    }
    
    weak var dateRangeDelegate: CreateEventViewController?
    private var datesRange: [Date]?
    private var firstDate: Date?
    private var lastDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Background Colour")
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        calendar.backgroundColor = UIColor(named: "Background Colour")
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
            
//            print("datesRange contains: \(datesRange!)")
            
            return
        }
        
        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                
//                print("datesRange contains: \(datesRange!)")
                
                return
            }
            
            let range = datesRange(from: firstDate!, to: date)
            
            lastDate = range.last
            
            for date in range {
                calendar.select(date)
            }
            
            datesRange = range
            
//            print("datesRange contains: \(datesRange!)")
            
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
            
//            print("datesRange contains: \(datesRange!)")
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:
        
        // NOTE: the is a REDUANDENT CODE:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            
            lastDate = nil
            firstDate = nil
            
            datesRange = []
            print("datesRange contains: \(datesRange!)")
        }
    }
}

