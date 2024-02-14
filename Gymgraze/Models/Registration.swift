//
//  Registration.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 08/02/2024.
//

import Foundation

struct Registration: Codable {
    var email: String
    var password: String
    var name: String
    var age: Int
    var weight: Double
    var height: Int
}
