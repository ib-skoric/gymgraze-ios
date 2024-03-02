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
    var updated_at: Date
}

struct GoalPayload: Codable {
    var kcal: Int
    var steps: Int
    var exercise: Int
}
