//
//  Exercise.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/03/2024.
//

import Foundation

class Exercise: Codable, Identifiable, Equatable, ObservableObject {
    
    
    let id: Int
    let name: String
    let exerciseType: String
    @Published var exerciseSets: [ExerciseSet]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case exerciseType = "exercise_type"
        case exerciseSets = "exercise_sets"
    }
    
    class ExerciseSet: Codable, Identifiable {
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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        exerciseType = try container.decode(String.self, forKey: .exerciseType)
        exerciseSets = try container.decodeIfPresent([ExerciseSet].self, forKey: .exerciseSets)
    }
    
    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
            try container.encode(exerciseType, forKey: .exerciseType)
            try container.encode(exerciseSets, forKey: .exerciseSets)
        }
    
    init() {
        id = 0
        name = ""
        exerciseType = ""
        exerciseSets = []
    }
}


