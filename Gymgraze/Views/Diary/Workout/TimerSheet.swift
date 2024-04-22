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
        VStack {
            
            Spacer()
            
            Text("\(timerValue / 60):\(String(format: "%02d", timerValue % 60))")
                .onReceive(timer, perform: { _ in
                    if timerValue > 0 {
                        timerValue -= 1
                    }
                    if timerValue == 0 {
                        dismiss()
                    }
                })
                .font(.system(size: 80))
            
            Spacer()
            
            HStack {
                Button(action: {
                    timerValue += 10
                }, label: {
                    Text("+10s")
                })
                .padding()
                .buttonStyle(CTAButtonSmall())
                
                
                Button(action: {
                    timerValue += 20
                }, label: {
                    Text("+20s")
                })
                .padding()
                .buttonStyle(CTAButtonSmall())
                
                
                Button(action: {
                    timerValue += 30
                }, label: {
                    Text("+30s")
                })
                .padding()
                .buttonStyle(CTAButtonSmall())
                
            }
            .foregroundStyle(.orange)

            
            Spacer()
            
            Button {
                timerValue = initialValue
                dismiss()
            } label: {
                Text("Skip rest")
            }
            .buttonStyle(CTAButton())
        }
        .padding()
    }
}

#Preview {
    TimerSheet(timerValue: .constant(150))
}
