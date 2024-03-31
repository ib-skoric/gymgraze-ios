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
        VStack(alignment: .leading) {
            Text("🏋️‍♀️ Workout details")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            Text("Date: \(workout.date)")
                .font(.subheadline)
                .fontWeight(.light)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            Text("Duration: \(workout.date)")
                .font(.subheadline)
                .fontWeight(.light)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        .padding()

        ForEach(workout.exercises) { exercise in
            Text(exercise.name)
            Text(exercise.exerciseCategory)
        }
        
        Spacer()
    }
}

#Preview {
    WorkoutDetailView(workout: Workout())
}
