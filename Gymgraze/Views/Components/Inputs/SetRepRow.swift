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
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = 60
    @State private var showTimerSheet = false
    
    var completedSetColor: Color {
        completed ? .green : .primary
    }
    
    var setRepEmpty: Bool {
        repWeight.isEmpty || repCount.isEmpty
    }
    
    
    var body: some View {
        if readOnly == false {
            editableView
        } else {
            readOnlyView
        }
    }
    
    private var editableView: some View {
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
            .sheet(isPresented: $showTimerSheet) {
                TimerSheet(timerValue: $timeRemaining)
                    .interactiveDismissDisabled(timeRemaining > 0)
            }
            .disabled(repWeight.isEmpty || repCount.isEmpty)
        }
    }
    
    private var readOnlyView: some View {
        VStack {
            HStack {
                Text(String(format: "%.1f", set.weight ?? 0.0))
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                Spacer()
                
                Text("\(set.reps ?? 0)")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

//#Preview {
//    SetRepRow(set: Exercise.ExerciseSet(), exerciseId: 1, readOnly: true)
//}
