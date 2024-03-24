//
//  Exercise.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/03/2024.
//

import Foundation

struct Exercise: Codable, Identifiable {
    let id: Int
    let name: String
    let exerciseType: String
    var exerciseSets: [ExerciseSet]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case exerciseType = "exercise_type"
        case exerciseSets = "sets"
    }
    
    struct ExerciseSet: Codable, Identifiable {
        let id: Int
        let exerciseId: Int
        let weight: Double
        let reps: Int
        
        enum CodingKeys: String, CodingKey {
            case id
            case exerciseId = "exercise_id"
            case reps
            case weight
        }
        
        init(id: Int, exerciseId: Int, weight: Double, reps: Int) {
            self.id = id
            self.exerciseId = exerciseId
            self.weight = weight
            self.reps = reps
        }
    }
    
    init() {
        id = 0
        name = ""
        exerciseType = ""
        exerciseSets = []
    }
}


