//
//  Exercise.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/03/2024.
//

import Foundation

class Exercise: Codable, Identifiable, ObservableObject {
    var id: Int
    var name: String
    var exerciseTypeId: Int
    var duration: Int
    var timer: Int?
    var exerciseCategory: String
    @Published var exerciseSets: [ExerciseSet]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case duration
        case timer
        case exerciseTypeId = "exercise_type_id"
        case exerciseCategory = "exercise_category"
        case exerciseSets = "exercise_sets"
    }
    
    class ExerciseSet: Codable, Identifiable {
        let id: Int
        let exerciseId: Int
        var weight: Double?
        var reps: Int?
        
        enum CodingKeys: String, CodingKey {
            case id
            case exerciseId = "exercise_id"
            case reps
            case weight
        }
        
        init() {
            id = 0
            exerciseId = 0
            weight = nil
            reps = nil
        }
        
        init(id: Int, exerciseId: Int) {
            self.id = id
            self.exerciseId = exerciseId
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
        duration = try container.decode(Int.self, forKey: .duration)
        name = try container.decode(String.self, forKey: .name)
        exerciseTypeId = try container.decode(Int.self, forKey: .exerciseTypeId)
        exerciseCategory = try container.decode(String.self, forKey: .exerciseCategory)
        exerciseSets = try container.decodeIfPresent([ExerciseSet].self, forKey: .exerciseSets)
    }
    
    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(duration, forKey: .duration)
            try container.encode(name, forKey: .name)
            try container.encode(exerciseTypeId, forKey: .exerciseTypeId)
            try container.encode(exerciseCategory, forKey: .exerciseCategory)
            try container.encode(exerciseSets, forKey: .exerciseSets)
        }
    
    init() {
        id = 0
        duration = 0
        name = ""
        exerciseTypeId = 0
        exerciseCategory = ""
        exerciseSets = []
    }
    
    init(id: Int, name: String, duration: Int, timer: Int, exerciseTypeId: Int, exerciseCategory: String, exerciseSets: [ExerciseSet]?) {
        self.id = id
        self.name = name
        self.timer = timer
        self.duration = duration
        self.exerciseTypeId = exerciseTypeId
        self.exerciseCategory = exerciseCategory
        self.exerciseSets = exerciseSets
    }
    
    init(templateExercise: TemplateExercise, exerciseSets: [ExerciseSet]) {
        self.id = templateExercise.id
        self.name = templateExercise.name
        self.timer = templateExercise.timer
        self.duration = 0
        self.exerciseTypeId = templateExercise.exerciseTypeId
        self.exerciseCategory = ""
        self.exerciseSets = exerciseSets
    }
}

struct ExerciseToAPI: Encodable {
    var name: String
    var exercise_category: String
    var exercise_type_id: Int
    var duration: Int
    var workout_id: Int
    var exercise_sets_attributes: [ExerciseSetToAPI]
    
    struct ExerciseSetToAPI: Encodable {
        var reps: Int
        var weight: Double
        var workout_id: Int
    }
    
    init(exercise: Exercise, workoutId: Int) {
        self.name = exercise.name
        self.exercise_category = exercise.exerciseCategory
        self.duration = exercise.duration
        self.exercise_type_id = exercise.exerciseTypeId
        self.workout_id = workoutId
        self.exercise_sets_attributes = []
        
        for set in exercise.exerciseSets ?? []{
            let exerciseSet = ExerciseSetToAPI(reps: set.reps ?? 0, weight: set.weight ?? 0.0, workout_id: workoutId)
            self.exercise_sets_attributes.append(exerciseSet)
        }
    }
}


