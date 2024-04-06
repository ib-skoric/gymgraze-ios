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
    var updatedAt: Date?
    
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
        
        if let updatedAtTimestamp = try container.decodeIfPresent(Double.self, forKey: .updatedAt) {
            updatedAt = Date(timeIntervalSince1970: updatedAtTimestamp)
        }
    }
}

struct GoalPayload: Codable {
    var kcal: Int
    var steps: Int
    var exercise: Int
}
