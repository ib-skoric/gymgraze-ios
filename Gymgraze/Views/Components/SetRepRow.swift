//
//  SetRepRow.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 24/03/2024.
//

import SwiftUI

struct SetRepRow: View {
    
    @State private var repWeight: String = ""
    @State private var repCount: String = ""
    @State var exerciseId: Int
    @State var completed: Bool = false
    
    var completedSetColor: Color {
        completed ? .green : .primary
    }
    
    var body: some View {
        HStack(alignment: .center) {
            TextField("Weight", text: $repWeight)
                .font(.subheadline)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .foregroundColor(completedSetColor)
            
            TextField("Reps", text: $repCount)
                .font(.subheadline)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .foregroundColor(completedSetColor)
            
            Button(action: {
                completed.toggle()
            }, label: {
                Image(systemName: "checkmark")
                    .foregroundColor(.orange)
            })
        }
    }
}

#Preview {
    SetRepRow(exerciseId: 1)
}
