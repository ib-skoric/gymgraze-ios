//
//  WorkoutTemplateRow.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 06/04/2024.
//

import SwiftUI

struct WorkoutTemplateRow: View {
    // variables
    @State var workoutTemplate: WorkoutTemplate
    
    var body: some View {
        // show template name
        VStack(alignment: .leading) {
            Text("**\(workoutTemplate.name)**")
                .foregroundStyle(.orange)
            
            // loop over templateExercises and show their names
            ForEach(workoutTemplate.templateExercises) { templateExercise in
                Text(templateExercise.name)
                    .fontWeight(.light)
                    .foregroundStyle(.gray)
            }
        }
        .padding()
    }
}
