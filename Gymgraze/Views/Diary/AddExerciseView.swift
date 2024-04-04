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
                let isCardio = exerciseType.exerciseCategory == "cardio"
                let isExerciseInWorkout = viewModel.workoutExercies.contains(where: { $0.exerciseTypeId == exerciseType.id })
                
                HStack {
                    exerciseTypeImage(isCardio: isCardio)
                    Text(exerciseType.name)
                    Spacer()
                    if isExerciseInWorkout {
                        Image(systemName: "checkmark")
                            .foregroundColor(.orange)
                    }
                }
                .onTapGesture {
                    handleTapOnExercise(exerciseType: exerciseType, isExerciseInWorkout: isExerciseInWorkout)
                }
            }
            .navigationTitle("Add exercise")
            .toolbar {
                AddExerciseTypeDropdown(isAddStrengthExerciseShown: $showAddStrengthExerciseType, isAddCardioExerciseShown: $showAddCardioExerciseType)
            }
            .alert("🏋️‍♂️", isPresented: $showAddStrengthExerciseType, actions: {
                AddExerciseTypeAlert(newExerciseName: $newExerciseName, category: "strength", viewModel: viewModel)
            }, message: {
                Text("Create new strength exercise")
            })
            .alert("🏃‍♂️", isPresented: $showAddCardioExerciseType, actions: {
                AddExerciseTypeAlert(newExerciseName: $newExerciseName, category: "cardio", viewModel: viewModel)
            }, message: {
                Text("Create new cardio exercise")
            })
        }
        .onAppear {
            viewModel.fetchExercises()
        }
        .accentColor(.orange)
    }
    
    private func exerciseTypeImage(isCardio: Bool) -> some View {
        if isCardio {
            return Image(systemName: "figure.run")
                .foregroundColor(.red)
        } else {
            return Image(systemName: "dumbbell.fill")
                .foregroundColor(.orange)
        }
    }
    
    private func handleTapOnExercise(exerciseType: ExerciseType, isExerciseInWorkout: Bool) {
        handleHistoricalData(exerciseType: exerciseType)
    }
    
    func handleHistoricalData(exerciseType: ExerciseType) {
        if !exerciseType.historicalSetRepData.isEmpty {
            // create the same number of exercise sets as before
            let exerciseSets = exerciseType.historicalSetRepData.map { setRepData in
                // create an 'empty' exercise sets (no weight or reps) 
                Exercise.ExerciseSet(id: Int.random(in: 1...999999999), exerciseId: exerciseType.id)
            }
            
            // create new exercise with that amount of set/reps
            let newExercise = Exercise(id: Int.random(in: 1...999999999), name: exerciseType.name, duration: 0, exerciseTypeId: exerciseType.id, exerciseCategory: exerciseType.exerciseCategory, exerciseSets: exerciseSets)
            
            DispatchQueue.main.async {
                viewModel.workoutExercies.append(newExercise)
                dismiss()
            }

        } else {
            let newExercise = Exercise(id: Int.random(in: 1...999999999), name: exerciseType.name, duration: 0, exerciseTypeId: exerciseType.id, exerciseCategory: exerciseType.exerciseCategory, exerciseSets: nil)
            viewModel.workoutExercies.append(newExercise)
            
            DispatchQueue.main.async {
                dismiss()
            }
        }
    }
}

//#Preview {
//    AddExerciseView()
//}
