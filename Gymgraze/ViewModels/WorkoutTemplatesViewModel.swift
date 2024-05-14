//
//  WorkoutTemplatesViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 06/04/2024.
//

import Foundation

class WorkoutTemplatesViewModel: ObservableObject {
    /// Published properties used by different views to update UI
    @Published var workoutTemplates: [WorkoutTemplate] = []
    
    /// method for fetching workout templates
    func fetchWorkoutTemplates() {
        
        // call user service to fetch workout templates
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
    
    /// method for deleting workout template
    func deleteWorkoutTemplate(id: Int) {
        
        // call user service to delete workout template
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
