//
//  AddExerciseView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 24/03/2024.
//

import SwiftUI

struct AddExerciseView: View {
    
    @ObservedObject var viewModel: AddWorkoutViewModel
    @State var showWorkoutView: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List(viewModel.exercises) { exercise in
                HStack {
                    if (exercise.exerciseType == "cardio") {
                        Image(systemName: "figure.run")
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "dumbbell.fill")
                            .foregroundColor(.orange)
                    }
                    
                    Text(exercise.name)
                    
                    Spacer()
                    
                    if viewModel.workoutExercies.contains(where: { $0 == exercise }) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.orange)
                    }

                }
                .onTapGesture {
                
                    if viewModel.workoutExercies.contains(where: { $0 == exercise }) {
                        viewModel.workoutExercies.removeAll(where: { $0 == exercise })
                    } else {
                        viewModel.workoutExercies.append(exercise)
                        print(viewModel.workoutExercies)
                    }
                    
                    dismiss()
                }
                
            }
            .navigationTitle("Add exercise")
        }
        .onAppear {
            viewModel.fetchExercises()
        }
    }
}

//#Preview {
//    AddExerciseView()
//}
