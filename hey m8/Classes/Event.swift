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
    var times: Array<PotentialTime>?
    var locations: PotentialLocation
    
    private enum CodingKeys: String, CodingKey {
        case name, descriptor, groupId, locations
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decodeIfPresent(String.self, forKey: .name)!
        descriptor = try values.decodeIfPresent(String.self, forKey: .descriptor)
        groupId = try values.decodeIfPresent(String.self, forKey: .groupId)!
        locations = try values.decodeIfPresent(PotentialLocation.self, forKey: .locations)!

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(descriptor, forKey: .descriptor)
        try container.encode(name, forKey: .name)
        try container.encode(groupId, forKey: .groupId)
        try container.encode(locations, forKey: .locations)
        
//        try container.encode(location.placemark.coordinate.latitude, forKey: .latitude)
//        try container.encode(location.placemark.coordinate.longitude, forKey: .longitude)
    }
        
}
