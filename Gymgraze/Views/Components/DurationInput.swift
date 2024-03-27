//
//  DurationField.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 27/03/2024.
//

import SwiftUI

struct DurationInput: View {
    
    @State var exercise: Exercise
    @State var duration: String = ""
    @State var completed: Bool = false
    
    
    var body: some View {
        
        var completedSetColor: Color {
            completed ? .green : .primary
        }
        
        HStack(alignment: .center) {
            TextField("Duration", text: $duration)
                .font(.subheadline)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .foregroundColor(completedSetColor)
                .frame(width: 100)
                .padding(.trailing)
            
            Button(action: {
                exercise.duration = Int(duration) ?? 0
                completed.toggle()
            }, label: {
                Image(systemName: "checkmark")
                    .foregroundColor(.orange)
            })
        }
    }
}

#Preview {
    DurationInput(exercise: Exercise(), duration: "")
}
