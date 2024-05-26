//
//  SetRepRow.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 24/03/2024.
//

import SwiftUI

struct SetRepRow: View {
    
    // state and env variables to handle view updates
    @State private var repWeight: String = ""
    @State private var repCount: String = ""
    @State var set: Exercise.ExerciseSet
    @State var exerciseId: Int
    @State var completed: Bool = false
    @State var readOnly: Bool
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = 0
    @State private var showTimerSheet = false
    @ObservedObject var exercise: Exercise
    
    // check if completed to set colour to green
    var completedSetColour: Color {
        completed ? .green : .primary
    }
    
    var setRepEmpty: Bool {
        repWeight.isEmpty || repCount.isEmpty
    }
    
    // main view
    var body: some View {
        // compute which view to show based on read only value
        if readOnly == false {
            editableView
        } else {
            readOnlyView
        }
    }
    
    private var editableView: some View {
        HStack(alignment: .center) {
            // weight and reps input fields
            TextField("Weight", text: $repWeight)
                .font(.subheadline)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .foregroundColor(completedSetColour)
                .accessibilityLabel("Weight input field")
            
            TextField("Reps", text: $repCount)
                .font(.subheadline)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .foregroundColor(completedSetColour)
                .accessibilityLabel("Reps input field")
            
            // button to complete set
            Button(action: {
                // convert reps and sets into double/int
                set.reps = Int(repCount) ?? 0
                set.weight = Double(repWeight) ?? 0.0
                completed.toggle()
                if completed {
                    // show timer
                    self.showTimerSheet.toggle()
                }
            }, label: {
                Image(systemName: "checkmark")
                    .foregroundColor(setRepEmpty ? .gray : .orange)
            })
            .sheet(isPresented: $showTimerSheet) {
                TimerSheet(timerValue: $timeRemaining)
                    .interactiveDismissDisabled(timeRemaining > 0)
            }
            // disable it if set/rep are empty
            .disabled(repWeight.isEmpty || repCount.isEmpty)
            .accessibilityLabel("Complete set button")
        }
        .onAppear {
            self.timeRemaining = exercise.timer ?? 90
        }
        .onChange(of: exercise.timer ?? 0) { oldValue, newValue in
            if oldValue != newValue {
                self.timeRemaining = newValue
            }
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
