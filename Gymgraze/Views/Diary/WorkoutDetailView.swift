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
        Text("This is a workout detail view")
    }
}

#Preview {
    WorkoutDetailView(workout: Workout())
}
