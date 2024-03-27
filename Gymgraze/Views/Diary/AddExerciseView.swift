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
    @State var showAddStrengthExerciseType: Bool = false
    @State var showAddCardioExerciseType: Bool = false
    @State var newExerciseName: String = ""
    @State var newExerciseCategory: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List(viewModel.exercisesTypes, id: \.id) { exerciseType in
                HStack {
                    if (exerciseType.exerciseCategory == "cardio") {
                        Image(systemName: "figure.run")
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "dumbbell.fill")
                            .foregroundColor(.orange)
                    }
                    
                    Text(exerciseType.name)
                    
                    Spacer()
                    
                    if viewModel.workoutExercies.contains(where: { $0.exerciseTypeId == exerciseType.id }) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.orange)
                    }
                    
                }
                .onTapGesture {
                    
                    if viewModel.workoutExercies.contains(where: { $0.exerciseTypeId == exerciseType.id }) {
                        viewModel.workoutExercies.removeAll(where: { $0.exerciseTypeId == exerciseType.id })
                    } else {
                        viewModel.workoutExercies.append(Exercise(id: Int.random(in: 1...999999999), name: exerciseType.name, exerciseTypeId: exerciseType.id, exerciseCategory: exerciseType.exerciseCategory, exerciseSets: nil))
                        print(viewModel.workoutExercies)
                    }
                    
                    dismiss()
                }
                
            }
            .navigationTitle("Add exercise")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAddExerciseType = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .alert("Login", isPresented: $showAddStrengthExerciseType, actions: {
                        
                        TextField("Name", text: $newExerciseName)
                        Button("Add", action: {})
                        Button("Cancel", role: .cancel, action: {})
                    }, message: {
                        Text("🏋️‍♂️ Create new strength exercise type")
                    })
        }
        .onAppear {
            viewModel.fetchExercises()
        }
    }
}

//#Preview {
//    AddExerciseView()
//}
