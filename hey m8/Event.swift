//
//  Event.swift
//  hey m8
//
//  Created by Christina Li on 25/5/21.
//

import Foundation

class Event: NSObject {
    var name: String
    var eventID: String
//    var members: Array<String> //This is a user's ID in firestore
    
    init(name: String, eventID: String) {
        self.name = name
        self.eventID = eventID
    }
}
