//
//  User.swift
//  hey m8
//
//  Created by Christina Li on 23/5/21.
//

import Foundation

class User: NSObject {
    var id: String
    var displayName: String
    var email: String?
    var groupID: String?
    var phoneNumber: Int?
    
    init(id: String, displayName: String) {
        self.id = id
        self.displayName = displayName
    }
}
