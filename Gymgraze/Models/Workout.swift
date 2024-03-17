//
//  Workout.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/03/2024.
//

import Foundation

struct Workout: Codable {
    let id: Int
    let exercises: [Exercise]
    
    init() {
        id = 0
        exercises = []
    }
}
