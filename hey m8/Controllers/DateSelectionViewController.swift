//
//  DateSelectionViewController.swift
//  hey m8
//
//  Created by Christina Li on 11/5/21.
//
//https://stackoverflow.com/questions/49856370/how-to-select-range-fscalendar-in-swift

import UIKit
import FSCalendar

class DateSelectionViewController: UIViewController, FSCalendarDelegate {
    @IBOutlet weak var calendar: FSCalendar!
    private var datesRange: [Date]?
    
    // first date in the range
    private var firstDate: Date?
    // last date in the range
    private var lastDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        
        // Do any additional setup after loading the view.
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
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
            
            print("datesRange contains: \(datesRange!)")
            
            return
        }
        
        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                
                print("datesRange contains: \(datesRange!)")
                
                return
            }
            
            let range = datesRange(from: firstDate!, to: date)
            
            lastDate = range.last
            
            for d in range {
                calendar.select(d)
            }
            
            datesRange = range
            
            print("datesRange contains: \(datesRange!)")
            
            return
        }
        
        // both are selected:
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

