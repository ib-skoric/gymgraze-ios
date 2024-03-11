//
//  Goal.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

/// Goal object model
struct Goal: Codable {
    var kcal: Int
    var steps: Int
    var exercise: Int
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case kcal
        case steps
        case exercise
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        kcal = try container.decode(Int.self, forKey: .kcal)
        steps = try container.decode(Int.self, forKey: .steps)
        exercise = try container.decode(Int.self, forKey: .exercise)
        
        // Decode the ISO8601 date string into a Swift Date
        let isoDate = try container.decode(String.self, forKey: .updatedAt)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        updatedAt = dateFormatter.date(from: isoDate) ?? Date()
    }
}

struct GoalPayload: Codable {
    var kcal: Int
    var steps: Int
    var exercise: Int
}
