//
//  addMemberDelegate.swift
//  hey m8
//
//  Created by Christina Li on 24/5/21.
//

import Foundation

protocol AddMemberDelegate: AnyObject {
    func addMember(newMember: User) -> Bool
}
