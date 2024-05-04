//
//  AddWorkoutViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 24/03/2024.
//

import Foundation
import Combine

class AddWorkoutViewModel: ObservableObject {
    /// Published properties used by different views to update UI
    @Published var exercisesTypes: [ExerciseType] = []
    @Published var workoutExercies: [Exercise] = []
    @Published var isLoading: Bool = false
    @Published var date: Date = Date()
    @Published var templateName: String = ""
    // start time used to track the duration of the workout
    var startTime = Date()
    
    /// method for resetting the view model when the workout is finished
    func reset() {
        workoutExercies = []
        date = Date()
        startTime = Date()
    }
    
    /// method for fetching exercises that can be added to the workout
    func fetchExercises() {
        self.isLoading = true
        
        // the API service call to fetch exercises
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
    
    /// method to save the workout to the diary
    func saveWorkout(completion: @escaping (Result<Bool, APIError>) -> Void) {
        // calculate duration
        let endTime = Date()
        let duration = Int(endTime.timeIntervalSince(startTime)) / 60
        
        // call the API service to save the workout
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
    
    /// method to save a template of the workout
    func saveTemplate(completion: @escaping (Result<Bool, APIError>) -> Void) {
        self.isLoading = true
        // create an array of TemplateExercise objects
        var templateExercises: [TemplateExerciseToAPI] = []
        
        // loop over all the exercises and append it
        for exercise in workoutExercies {
            templateExercises.append(TemplateExerciseToAPI(exercise_type_id: exercise.exerciseTypeId, exercise_category: exercise.exerciseCategory))
        }
        
        // create payload for API
        let template = TemplateToAPI(name: templateName, template_exercises_attributes: templateExercises)
        
        // call the API service to save the template
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
