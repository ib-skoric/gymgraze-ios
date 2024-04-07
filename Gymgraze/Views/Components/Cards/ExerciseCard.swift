//
//  ExerciseCard.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 24/03/2024.
//

import SwiftUI

struct ExerciseCard: View {
    
    @ObservedObject var exercise: Exercise
    @ObservedObject var viewModel: AddWorkoutViewModel
    @State var isDeleteWorkoutAlertShown: Bool = false
    
    func returnCurrentExerciseSetHistoricalData(index: Int) -> String {
        // get current exercise set historical data
        let exerciseType = viewModel.exercisesTypes.filter { $0.id == exercise.exerciseTypeId }.first
        
        // get historical set/rep data for that type
        let historicalData = exerciseType?.historicalSetRepData
        
        if let historicalData = historicalData, index < historicalData.count {
            // get the current set/rep data
            let currentSetRepData = historicalData[index]
            
            // return the data as string
            return "\(currentSetRepData.weight ?? "null")kg x \(currentSetRepData.reps ?? 0)"
        } else {
            return "-"
        }
    }

    
    var body: some View {
        VStack {
            viewHeading
            setRows
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        .padding(.bottom)
        .alert(isPresented: $isDeleteWorkoutAlertShown) {
            Alert(title: Text("Delete exercise"), message: Text("Are you sure you want to delete this exercise?"), primaryButton: .destructive(Text("Delete")) {
                viewModel.workoutExercies.removeAll(where: { $0.id == exercise.id })
            }, secondaryButton: .cancel())
        }
        .onAppear {
            viewModel.fetchExercises()
        }
    }
    
    private var addSetButton: some View {
        Button(action: {
            let set = Exercise.ExerciseSet(id: Int.random(in: 1...999999999), exerciseId: exercise.id, weight: 0.0, reps: 0)
            
            if exercise.exerciseSets == nil {
                exercise.exerciseSets = []
            }
            
            exercise.exerciseSets?.append(set)
            print(exercise.exerciseSets ?? [])
        }, label: {
            Text("Add set")
                .foregroundColor(.orange)
        })
    }
    
    private var setRows: some View {
        ForEach(Array(exercise.exerciseSets?.indices ?? 0..<0), id: \.self) { index in
            if let set = exercise.exerciseSets?[index] {
                HStack(alignment: .center) {
                    Button(action: {
                        exercise.exerciseSets?.remove(at: index)
                    }, label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.gray)
                    })
                    
                    Text(returnCurrentExerciseSetHistoricalData(index: index))
                        .padding([.leading, .trailing])
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    
                    SetRepRow(set: set, exerciseId: set.exerciseId, readOnly: false)
                }
                .padding(.bottom)
            }
        }
    }
    
    private var viewHeading: some View {
        HStack {
            Button(action: {
                isDeleteWorkoutAlertShown = true
            }, label: {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.gray)
            })
            
            Spacer()
            
            Text(exercise.name)
                .fontWeight(.bold)
            
            Spacer()
            
            if (exercise.exerciseCategory != "cardio") {
                addSetButton
            } else {
                DurationInput(exercise: exercise)
            }
        }
    }
}

//#Preview {
//    ExerciseCard(exercise: Exercise())
//}
