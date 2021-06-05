//
//  Event.swift
//  hey m8
//
//  Created by Christina Li on 25/5/21.
//

import Foundation
import FirebaseFirestoreSwift

class Event: NSObject, Codable {
    internal init(name: String, descriptor: String? = nil, groupId: String, times: Array<PotentialTime>, locations: PotentialLocation) {
        self.name = name
        self.descriptor = descriptor
        self.groupId = groupId
        self.times = times
        self.locations = locations
    }
    
    @DocumentID var id: String?
    var name: String
    var descriptor: String?
    var groupId: String
    var times: Array<PotentialTime>
    var locations: PotentialLocation
}
