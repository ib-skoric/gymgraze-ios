//
//  Workout.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/03/2024.
//

import Foundation

struct Workout: Codable, Identifiable {
    let id: Int
    let date: String
    let workoutDiaryEntryId: Int
    let duration: Int?
    let exercises: [Exercise]
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case workoutDiaryEntryId = "workout_diary_entry_id"
        case duration
        case exercises
    }
    
    init() {
        id = 0
        date = ""
        workoutDiaryEntryId = 0
        duration = 0
        exercises = []
    }
    
    init(id: Int, date: String, workoutDiaryEntryId: Int, duration: Int, exercises: [Exercise]) {
        self.id = id
        self.date = date
        self.workoutDiaryEntryId = workoutDiaryEntryId
        self.duration = duration
        self.exercises = exercises
    }
}
