//
//  AddExerciseTypeMenu.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 27/03/2024.
//

import SwiftUI

struct AddExerciseTypeDropdown: View {
    // state and env variables to handle view updates
    @Binding var isAddStrengthExerciseShown: Bool
    @Binding var isAddCardioExerciseShown: Bool
    
    var body: some View {
        Menu {
            Button(action: {
                isAddStrengthExerciseShown = true
            }, label: {
                Label("Add strength exercise", systemImage: "dumbbell.fill")
            })
            .accessibilityLabel("Add strength exercise button")
            
            Button(action: {
                isAddCardioExerciseShown = true
            }, label: {
                Label("Add cardio exercise", systemImage: "figure.run")
            })
            .accessibilityLabel("Add cardio exercise button")
            
        } label: {
            Label("", systemImage: "plus")
                .font(.system(size: 25))
        }
        .padding(.trailing)
    }
}

#Preview {
    AddExerciseTypeDropdown(isAddStrengthExerciseShown: .constant(false), isAddCardioExerciseShown: .constant(false))
}
