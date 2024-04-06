//
//  WorkoutTemplate.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 06/04/2024.
//

import Foundation

struct WorkoutTemplate: Codable, Identifiable {
    let id: Int
    let name: String
    let createdAt: Date
    let templateExercises: [TemplateExercise]
    
    init() {
        id = 0
        name = ""
        templateExercises = []
        createdAt = Date()
    }
    
    init(id: Int, name: String, createdAt: Date, templateExercises: [TemplateExercise]) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.templateExercises = templateExercises
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt = "created_at"
        case templateExercises = "template_exercises"
    }
}

struct TemplateExercise: Codable, Identifiable {
    let id: Int
    let name: String
    let exerciseTypeId: Int
    var historicalSetRepData: [SetRepData]
    
    init() {
        id = 0
        name = ""
        exerciseTypeId = 0
        historicalSetRepData = []
    }
    
    init(id: Int, name: String, exerciseTypeId: Int, historicalSetRepData: [SetRepData]) {
        self.id = id
        self.name = name
        self.exerciseTypeId = exerciseTypeId
        self.historicalSetRepData = historicalSetRepData
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case exerciseTypeId = "exercise_type_id"
        case historicalSetRepData = "historical_set_rep_data"
    }
}
