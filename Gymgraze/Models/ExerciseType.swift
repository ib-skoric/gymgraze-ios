//
//  ExerciseType.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 26/03/2024.
//

import Foundation

struct ExerciseType: Codable, Identifiable, Equatable {
    
    static func == (lhs: ExerciseType, rhs: ExerciseType) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int
    var name: String
    var exerciseCategory: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case exerciseCategory = "exercise_category"
    }
}
