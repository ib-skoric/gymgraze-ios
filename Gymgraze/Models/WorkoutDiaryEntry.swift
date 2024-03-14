//
//  WorkoutDiaryEntry.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/03/2024.
//

import Foundation

struct WorkoutDiaryEntry: Codable {
    let id: Int
    let date: String
    let workouts: [Workout]
    
    init() {
        id = 0
        date = ""
        workouts = []
    }
}
