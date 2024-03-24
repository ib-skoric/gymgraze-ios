//
//  ExerciseCard.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 24/03/2024.
//

import SwiftUI

struct ExerciseCard: View {
    
    @State var exercise: Exercise
    
    var body: some View {
            VStack {
                    Text("Bench press")
                        .fontWeight(.bold)

                    if (exercise.exerciseSets?.isEmpty ?? true) {
                        Text("No sets added")
                    }
                
                    ForEach(exercise.exerciseSets ?? [], id: \.id) { set in
                        HStack {
                            Button(action: {
                                exercise.exerciseSets?.removeAll(where: { $0.id == set.id })
                            }, label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.gray)
                            })
                            .padding([.leading, .trailing])
                            
                            SetRepRow(exerciseId: set.exerciseId)
                                .padding(.bottom)
                        }
                    }
                
                Button(action: {
                    let set = Exercise.ExerciseSet(id: Int.random(in: 1...999999999), exerciseId: exercise.id, weight: 0.0, reps: 0)
                    
                    if exercise.exerciseSets == nil {
                        exercise.exerciseSets = []
                    }
                    
                    exercise.exerciseSets?.append(set)
                    print(exercise.exerciseSets ?? [])
                }, label: {
                    Text("Add set")
                })

                }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ExerciseCard(exercise: Exercise())
}
