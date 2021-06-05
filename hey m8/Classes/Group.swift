//
//  Group.swift
//  hey m8
//
//  Created by Christina Li on 23/5/21.
//

import Foundation

class Group: NSObject {
    var name: String
    var id: String
    var members: Array<String> //This is a user's ID in firestore
    
    init(name: String, groupID: String, members: Array<String>) {
        self.name = name
        self.id = groupID
        self.members = members
    }
}

