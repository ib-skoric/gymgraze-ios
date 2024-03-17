//
//  DiaryRow.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 20/02/2024.
//

import SwiftUI

struct WorkoutDiaryRow: View {
    
    var workout: Workout
    
    // TODO: Add actual data from the API to show truncated names of exercises that are part of this workout.
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Workout")
                    .font(.headline)
                Text("Running, bench press, squats...")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    WorkoutDiaryRow(workout: Workout())
}
