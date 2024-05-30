//
//  DiaryRow.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 20/02/2024.
//

import SwiftUI

struct WorkoutDiaryRow: View {
    
    // variables
    var workout: Workout
    
    var body: some View {
        HStack {
            // list all exercises within a workout
            VStack(alignment: .leading) {
                Text("Workout")
                    .font(.headline)
                ForEach(workout.exercises) { exercise in
                    Text(exercise.name)
                        .fontWeight(.light)
                        .foregroundStyle(.gray)
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    WorkoutDiaryRow(workout: Workout())
}
