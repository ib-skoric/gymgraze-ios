//
//  AddWorkoutViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 24/03/2024.
//

import Foundation
import Combine

class AddWorkoutViewModel: ObservableObject {
    
    @Published var exercisesTypes: [ExerciseType] = []
    @Published var workoutExercies: [Exercise] = []
    @Published var isLoading: Bool = false
    @Published var date: Date = Date()
    @Published var templateName: String = ""
    var startTime = Date()
    
    func reset() {
        workoutExercies = []
        date = Date()
        startTime = Date()
    }
    
    func fetchExercises() {
        self.isLoading = true
        UserService().fetchExercisesForUser { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let exerciseTypes):
                    self.exercisesTypes = exerciseTypes
                case .failure(let error):
                    print(error)
                }
                self.isLoading = false
            }
        }
    }
    
    func saveWorkout(completion: @escaping (Result<Bool, APIError>) -> Void) {
        var endTime = Date()
        var duration = Int(endTime.timeIntervalSince(startTime)) / 60
        
        DiaryService().saveWorkout(date: date, exercises: workoutExercies, duration: duration) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func saveTemplate(completion: @escaping (Result<Bool, APIError>) -> Void) {
        self.isLoading = true
        // create an array of TemplateExercise objects
        var templateExercises: [TemplateExerciseToAPI] = []
        
        for exercise in workoutExercies {
            templateExercises.append(TemplateExerciseToAPI(exercise_type_id: exercise.exerciseTypeId, exercise_category: exercise.exerciseCategory))
        }
        
        var template = TemplateToAPI(name: templateName, template_exercises_attributes: templateExercises)
        
        UserService().saveWorkoutTemplate(workoutTemplate: template) { result in
            switch result {
            case .success(_):
                self.isLoading = false
                completion(.success(true))
            case .failure(let error):
                print(error)
                self.isLoading = false
                completion(.failure(error))
            }
        }
    }
}
