//
//  ExerciseCard.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 24/03/2024.
//

import SwiftUI

struct ExerciseCard: View {
    
    @ObservedObject var exercise: Exercise
    
    var body: some View {
        VStack {
            HStack {
                Text(exercise.name)
                    .fontWeight(.bold)
                
                Spacer()
                
                if (exercise.exerciseCategory != "cardio") {
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
            }
            
            if (exercise.exerciseSets?.isEmpty ?? true && exercise.exerciseCategory != "cardio") {
                Text("No sets added")
            }
            
            ForEach(exercise.exerciseSets ?? [], id: \.id) { set in
                HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    Button(action: {
                        exercise.exerciseSets?.removeAll(where: { $0.id == set.id })
                    }, label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.gray)
                    })
                    
                    SetRepRow(exerciseId: set.exerciseId)
                }
                .padding(.bottom)
            }
            
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
    }
}

#Preview {
    ExerciseCard(exercise: Exercise())
}
