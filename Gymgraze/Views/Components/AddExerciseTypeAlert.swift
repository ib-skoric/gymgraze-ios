//
//  AddExerciseTypeAlert.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 27/03/2024.
//

import SwiftUI

struct AddExerciseTypeAlert: View {
    // state and env variables to handle view updates
    @Binding var newExerciseName: String
    var category: String
    @ObservedObject var viewModel: AddWorkoutViewModel
    
    var body: some View {
        TextField("Name", text: $newExerciseName)
            .accessibilityLabel("Exercise name text field")
        
        // button to create exercise via API
        Button("Add", action: {
            UserService().createExerciseType(name: newExerciseName, category: category) { result in
                switch result {
                case .success(let exerciseType):
                    viewModel.fetchExercises()
                    print(exerciseType)
                case .failure(let error):
                    print(error)
                }
            }
        })
        Button("Cancel", role: .cancel, action: {})
    }
}
