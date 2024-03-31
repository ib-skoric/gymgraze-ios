//
//  DiaryRow.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 20/02/2024.
//

import SwiftUI

struct WorkoutDiaryRow: View {
    
    var workout: Workout
    var index: Int
    
    // TODO: Add actual data from the API to show truncated names of exercises that are part of this workout.
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Workout \(index + 1)")
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
    WorkoutDiaryRow(workout: Workout(), index: 1)
}
