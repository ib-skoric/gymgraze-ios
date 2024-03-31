//
//  WorkoutDetailsView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 17/03/2024.
//

import SwiftUI

struct WorkoutDetailView: View {
    
    @State var workout: Workout = Workout()
    
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
            Text("Duration: \(workout.duration) min")
                .font(.subheadline)
                .fontWeight(.light)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        .padding()

        ForEach(workout.exercises) { exercise in
            WorkoutExerciseCard(exercise: exercise)
                .padding()
        }
        Spacer()
    }
}

#Preview {
    WorkoutDetailView(workout: Workout())
}
