//
//  AddExerciseView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 24/03/2024.
//

import SwiftUI

struct AddExerciseView: View {
    
    @ObservedObject var viewModel: AddWorkoutViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
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
                }
                .onTapGesture {
                    viewModel.workoutExercies.append(exercise)
                    self.presentationMode.wrappedValue.dismiss()
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
