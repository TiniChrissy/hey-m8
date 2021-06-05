//
//  Location.swift
//  hey m8
//
//  Created by Christina Li on 4/6/21.
//
// Help decoding https://stackoverflow.com/questions/61488292/custom-class-conformance-to-mkannotation-and-codable/61491122#61491122
// Useful codable reference https://peterfriese.dev/firestore-codable-the-comprehensive-guide/#mapping-simple-types-using-codable

import Foundation
import FirebaseFirestoreSwift
import MapKit

class PotentialLocation: NSObject, Codable {
    internal init(location: MKMapItem, votes: Int? = nil) {
        self.location = location
        self.votes = votes
    }
    
    @DocumentID var id: String?
    var location: MKMapItem
    var votes: Int? //TODO: Array of id of people who voted for this in future

    enum CodingKeys: String, CodingKey {
            case location, votes, longitude, latitude
        }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        votes = try values.decodeIfPresent(Int.self, forKey: .votes)
        
//        let isCurrentLocation = try values.decode(Bool.self, forKey: .location)
//        let name = try values.decode(String.self, forKey: .location)
//        let phoneNumber = try values.decode(String.self, forKey: .location)
//        let url = try values.decode(URL.self, forKey: .location)
//        let timeZone = try values.decode(TimeZone.self, forKey: .location)
//
//        let MKPointOfInterestCategory = try values.decode(String.self, forKey: .location)

        let latitude = try values.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try values.decode(CLLocationDegrees.self, forKey: .longitude)
        let locationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placeMark = MKPlacemark(coordinate: locationCoordinate2D)
        location = MKMapItem(placemark: placeMark)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(votes, forKey: .votes)
        try container.encode(location.placemark.coordinate.latitude, forKey: .latitude)
        try container.encode(location.placemark.coordinate.longitude, forKey: .longitude)
    }
        
}
