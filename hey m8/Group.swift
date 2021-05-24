//
//  Group.swift
//  hey m8
//
//  Created by Christina Li on 23/5/21.
//

import Foundation

class Group: NSObject {
    var name: String
    var groupID: Int
    var members: Array<String>
    
    init(name: String, groupID: Int, members: Array<String>) {
        self.name = name
        self.groupID = groupID
        self.members = members
    }
    
    
}

