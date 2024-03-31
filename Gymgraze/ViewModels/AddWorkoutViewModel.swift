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
    @Published var workoutAdded: Bool = false
    var startTime = Date()
    
    func fetchExercises() {
        self.isLoading = true
        UserService().fetchExercisesForUser { result in
            switch result {
            case .success(let exerciseTypes):
                self.exercisesTypes = exerciseTypes
            case .failure(let error):
                print(error)
            }
            self.isLoading = false
        }
    }
    
    func saveWorkout(completion: @escaping (Result<Bool, APIError>) -> Void) {
        var endTime = Date()
        var duration = Int(endTime.timeIntervalSince(startTime)) / 60
        
        DiaryService().saveWorkout(date: date, exercises: workoutExercies, duration: duration) { result in
            switch result {
            case .success(_):
                self.workoutAdded = true
                completion(.success(true))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
