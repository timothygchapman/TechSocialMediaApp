//
//  User.swift
//  YearLongProject
//
//  Created by Timothy Chapman on 7/3/24.
//

import Foundation

struct User: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var userUUID: UUID
    var secret: UUID
    var userName: String
    
    static var current: User?
}
