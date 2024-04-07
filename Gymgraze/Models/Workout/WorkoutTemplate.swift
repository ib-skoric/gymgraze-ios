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
    let createdAt: String
    let templateExercises: [TemplateExercise]
    
    init() {
        id = 0
        name = ""
        templateExercises = []
        createdAt = ""
    }
    
    init(id: Int, name: String, createdAt: String, templateExercises: [TemplateExercise]) {
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

struct TemplateExerciseToAPI: Codable {
    let exercise_type_id: Int
}

struct TemplateToAPI: Codable {
    let name: String
    let template_exercises_attributes: [TemplateExerciseToAPI]
}
