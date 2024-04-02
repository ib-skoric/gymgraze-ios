//
//  TimerSheet.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 31/03/2024.
//

import SwiftUI

struct TimerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var timerValue: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var initialValue: Int
    
    init(timerValue: Binding<Int>) {
            self._timerValue = timerValue
            self._initialValue = State(initialValue: timerValue.wrappedValue)
        }
    
    var body: some View {
        Text("\(timerValue)")
            .onReceive(timer, perform: { _ in
                if timerValue > 0 {
                    timerValue -= 1
                }
            })
        
        Spacer()
        
        Button {
            timerValue = initialValue
            dismiss()
        } label: {
            Text("Skip rest")
        }
        .buttonStyle(CTAButton())
    }
}

//#Preview {
//    TimerSheet()
//}
