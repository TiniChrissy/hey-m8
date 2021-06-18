//
//  Time.swift
//  hey m8
//
//  Created by Christina Li on 4/6/21.
//

import Foundation
import FirebaseFirestoreSwift

class PotentialDate: NSObject, Codable {
    internal init(time: Date, votes: Int? = nil) {
        self.time = time
        self.votes = votes
    }
    
    @DocumentID var id: String?
    var time: Date
    var votes: Int? //TODO: Array of id of people who voted for this in future
}
