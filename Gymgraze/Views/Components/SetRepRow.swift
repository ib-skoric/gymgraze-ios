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
    @State var set: Exercise.ExerciseSet
    @State var exerciseId: Int
    @State var completed: Bool = false
    @State var readOnly: Bool
    @State var showTimerSheet: Bool = false
    @State var timerValue: Int = 50
    
    var completedSetColor: Color {
        completed ? .green : .primary
    }
    
    var setRepEmpty: Bool {
        repWeight.isEmpty || repCount.isEmpty
    }
    
    
    var body: some View {
        if readOnly == false {
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
                    set.reps = Int(repCount) ?? 0
                    set.weight = Double(repWeight) ?? 0.0
                    print(set)
                    completed.toggle()
                    self.showTimerSheet.toggle()
                }, label: {
                    Image(systemName: "checkmark")
                        .foregroundColor(setRepEmpty ? .gray : .orange)
                })
                .disabled(repWeight.isEmpty || repCount.isEmpty)
            }
            .sheet(isPresented: $showTimerSheet, content: {
                TimerSheet(timerValue: $timerValue)
            })
        } else {
            VStack {
                HStack {
                    Text(String(format: "%.1f", set.weight))
                        .font(.subheadline)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)                    
                    Spacer()
                    
                    Text("\(set.reps)")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

#Preview {
    SetRepRow(set: Exercise.ExerciseSet(), exerciseId: 1, readOnly: true)
}
