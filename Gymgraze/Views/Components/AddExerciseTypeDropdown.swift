//
//  AddExerciseTypeMenu.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 27/03/2024.
//

import SwiftUI

struct AddExerciseTypeDropdown: View {
    @Binding var isAddStrengthExerciseShown: Bool
    @Binding var isAddCardioExerciseShown: Bool
    
    var body: some View {
        Menu {
            Button(action: {
                isAddStrengthExerciseShown = true
            }, label: {
                Label("Add strength exercise", systemImage: "dumbbell.fill")
            })
            
            Button(action: {
                isAddCardioExerciseShown = true
            }, label: {
                Label("Add cardio exercise", systemImage: "figure.run")
            })
            
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
