//
//  WorkoutTemplatesViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 06/04/2024.
//

import Foundation

class WorkoutTemplatesViewModel: ObservableObject {
    @Published var workoutTemplates: [WorkoutTemplate] = []
    
    func fetchWorkoutTemplates() {
        UserService().fetchWorkoutTemplates { result in
            switch result {
                case .success(let workoutTemplates):
                    self.workoutTemplates = workoutTemplates
                print(self.workoutTemplates)
                case .failure(let error):
                    print("Failed to fetch workout templates: \(error)")
            }
        }
    }
    
    func deleteWorkoutTemplate(id: Int) {
        UserService().deleteWorkoutTemplate(id: id) { result in
            switch result {
                case .success(let workoutTemplate):
                    self.fetchWorkoutTemplates()
                    print(workoutTemplate)
                case .failure(let error):
                    print(error)
            }
        }
    }
}
