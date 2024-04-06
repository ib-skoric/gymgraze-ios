//
//  WorkoutTemplate.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 06/04/2024.
//

import Foundation

struct WorkoutTemplate {
    let id: Int
    let name: String
    let templateExercises: [TemplateExercise]
    
    init() {
        id = 0
        name = ""
        templateExercises = []
    }
    
    init(id: Int, name: String, description: String, templateExercises: [TemplateExercise]) {
        self.id = id
        self.name = name
        self.templateExercises = templateExercises
    }
}

struct TemplateExercise {
    let id: Int
    let name: String
    let exerciseTypeId: Int
    
    init() {
        id = 0
        name = ""
        exerciseTypeId = 0
    }
    
    init(id: Int, name: String, exerciseTypeId: Int) {
        self.id = id
        self.name = name
        self.exerciseTypeId = exerciseTypeId
    }
}
