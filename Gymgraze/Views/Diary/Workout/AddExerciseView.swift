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
            // list of all excercise types
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
    
    /// function to display correct execrcise type icon
    private func exerciseTypeImage(isCardio: Bool) -> some View {
        if isCardio {
            return Image(systemName: "figure.run")
                .foregroundColor(.red)
        } else {
            return Image(systemName: "dumbbell.fill")
                .foregroundColor(.orange)
        }
    }
    
    /// functon to handle tapping on exercise (ie. adding it or removing it from the list) 
    func handleTapOnExercise(exerciseType: ExerciseType, isExerciseInWorkout: Bool) {
        if !isExerciseInWorkout {
            if !exerciseType.historicalSetRepData.isEmpty {
                var exerciseSets: [Exercise.ExerciseSet]
                let numberOfExerciseSets = exerciseType.historicalSetRepData.count
                
                // create that many exercise sets
                exerciseSets = (0..<numberOfExerciseSets).map { _ in
                    Exercise.ExerciseSet(id: Int.random(in: 1...999999999), exerciseId: exerciseType.id, weight: 0.0, reps: 0)
                }
                
                // create new exercise with that amount of set/reps
                let newExercise = Exercise(id: Int.random(in: 1...999999999), name: exerciseType.name, duration: 0, timer: exerciseType.timer, exerciseTypeId: exerciseType.id, exerciseCategory: exerciseType.exerciseCategory, exerciseSets: exerciseSets)
                
                DispatchQueue.main.async {
                    viewModel.workoutExercies.append(newExercise)
                    dismiss()
                }
            } else {
                let newExercise = Exercise(id: Int.random(in: 1...999999999), name: exerciseType.name, duration: 0, timer: exerciseType.timer, exerciseTypeId: exerciseType.id, exerciseCategory: exerciseType.exerciseCategory, exerciseSets: nil)
                viewModel.workoutExercies.append(newExercise)
                
                dismiss()
            }
        } else {
            let index = viewModel.workoutExercies.firstIndex { $0.exerciseTypeId == exerciseType.id }
            viewModel.workoutExercies.remove(at: index!)
            dismiss()
        }
    }
}
