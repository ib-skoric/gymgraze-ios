//
//  Exercise.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/03/2024.
//

import Foundation

struct Exercise: Codable {
    let id: Int
    let name: String
    let exerciseType: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case exerciseType = "exercise_type"
    }
}
