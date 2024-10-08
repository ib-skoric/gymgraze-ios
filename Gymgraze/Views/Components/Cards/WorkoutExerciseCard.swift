//
//  WorkoutExerciseCard.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 31/03/2024.
//

import SwiftUI

struct WorkoutExerciseCard: View {
    
    @ObservedObject var exercise: Exercise
    
    var body: some View {
        VStack {
            HStack {
                Text(exercise.name)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.orange)
                Spacer()
            }
            
            if (exercise.exerciseCategory == "strength") {
                HStack {
                    Text("Weight")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                    Text("Reps")
                        .fontWeight(.bold)
                }
                
                ForEach(exercise.exerciseSets ?? [], id: \.id) { set in
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                        SetRepRow(set: set, exerciseId: set.exerciseId, readOnly: true, exercise: exercise)
                    }
                }
                
                Divider()
                
            } else {
                HStack {
                    Text("Duration")
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(exercise.duration) min")
                }
                Divider()
            }
        }
    }
}

//#Preview {
//    WorkoutExerciseCard()
//}
