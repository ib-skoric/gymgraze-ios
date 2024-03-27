//
//  AddExerciseTypeAlert.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 27/03/2024.
//

import SwiftUI

struct AddExerciseTypeAlert: View {
    
    @Binding var newExerciseName: String
    var type: String
    
    var body: some View {
        TextField("Name", text: $newExerciseName)
        Button("Add", action: {})
        Button("Cancel", role: .cancel, action: {})
    }
}
