//
//  WorkoutDetailsView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 17/03/2024.
//

import SwiftUI

struct WorkoutDetailView: View {
    
    var workout: Workout
    
    var body: some View {
        Text(workout.date)
        ForEach(workout.exercises) { exercise in
            Text(exercise.name)
            Text(exercise.exerciseCategory)
        }
    }
}

#Preview {
    WorkoutDetailView(workout: Workout())
}
