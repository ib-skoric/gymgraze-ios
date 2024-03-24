//
//  AddWorkoutViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 24/03/2024.
//

import Foundation

class AddWorkoutViewModel: ObservableObject {
    
    @Published var exercises: [Exercise] = []
    @Published var workoutExercies: [Exercise] = []
    @Published var isLoading: Bool = false
    
    func fetchExercises() {
        self.isLoading = true
        DiaryService().fetchExercisesForUser { result in
            switch result {
            case .success(let exercises):
                self.exercises = exercises
            case .failure(let error):
                print(error)
            }
            self.isLoading = false
        }
    }
    
    func saveWorkout() {
        DiaryService().saveWorkout(workout: workout) { result in
            switch result {
            case .success(_):
                print("Workout saved")
            case .failure(let error):
                print(error)
            }
        }
    }
}
