//
//  User.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

struct User: Codable {
    var id: Int
    var email: String
    var name: String
    var age: Int
    var weight: String
    var height: Int
}
