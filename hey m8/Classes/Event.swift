//
//  Event.swift
//  hey m8
//
//  Created by Christina Li on 25/5/21.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

class Event: NSObject, Codable {
    internal init(name: String, descriptor: String? = nil, groupId: String, times: Array<PotentialDate>, location: PotentialLocation) {
        self.name = name
        self.descriptor = descriptor
        self.groupId = groupId
        self.times = times
        self.location = location
    }
    
    @DocumentID var id: DocumentReference?
    var name: String
    var descriptor: String?
    var groupId: String
    var times: Array<PotentialDate>?
    var location: PotentialLocation
    
    private enum CodingKeys: String, CodingKey {
        case name, descriptor, groupId, location, id
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(DocumentID<DocumentReference>.self, forKey: .id).wrappedValue
        name = try values.decodeIfPresent(String.self, forKey: .name)!
        descriptor = try values.decodeIfPresent(String.self, forKey: .descriptor)
        groupId = try values.decodeIfPresent(String.self, forKey: .groupId)!
        location = try values.decodeIfPresent(PotentialLocation.self, forKey: .location)!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(descriptor, forKey: .descriptor)
        try container.encode(name, forKey: .name)
        try container.encode(groupId, forKey: .groupId)
        try container.encode(location, forKey: .location)

    }
        
}
