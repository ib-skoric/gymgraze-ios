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
    
    var body: some View {
        Text("\(timerValue)")
            .onReceive(timer, perform: { _ in
                if timerValue > 0 {
                    timerValue -= 1
                }
            })
        
        Button {
            
        } label: {
            Text("Skip rest")
        }
        .buttonStyle(CTAButton())
    }
}

//#Preview {
//    TimerSheet()
//}
