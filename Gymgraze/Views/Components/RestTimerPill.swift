//
//  RestTimerPill.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 27/04/2024.
//

import SwiftUI

struct RestTimerPill: View {
    // state and env variables to handle view updates
    @State var restTimerValue: String
    @State var exerciseTypeId: Int
    @ObservedObject var exercise: Exercise
    @State var isAlertPresented: Bool = false
    
    var body: some View {
        HStack {
            Button(action: {
                isAlertPresented.toggle()
            }, label: {
                Image(systemName: "timer.circle.fill")
                    .foregroundStyle(.white)
                Text(convertSecondsToMinutesAndSeconds(seconds: Int(restTimerValue) ?? 0))
                    .foregroundStyle(.white)
            })
            .accessibilityLabel("Edit timer button")
        }
        .padding(5)
        .background(
            Capsule()
                .fill(Color.orange)
        )
        .alert("⏳ Edit timer", isPresented: $isAlertPresented, actions: {
            EditTimerAlert(restTimerValue: $restTimerValue, exerciseTypeId: exerciseTypeId, exercise: exercise)
        }, message: {})
        
    }
}
