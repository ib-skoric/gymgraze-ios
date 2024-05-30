//
//  TimerSheet.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 31/03/2024.
//

import SwiftUI

struct TimerSheet: View {
    
    // state and env variables to handle view updates
    @Environment(\.dismiss) private var dismiss
    @Binding var timerValue: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var initialValue: Int
    
    // initialiser to set the timer value
    init(timerValue: Binding<Int>) {
            self._timerValue = timerValue
            self._initialValue = State(initialValue: timerValue.wrappedValue)
        }
    
    var body: some View {
        VStack {
            
            Spacer()
            
            // format timer as minutes and seconds
            Text("\(timerValue / 60):\(String(format: "%02d", timerValue % 60))")
                .onReceive(timer, perform: { _ in
                    if timerValue > 0 {
                        withAnimation {
                            timerValue -= 1
                        }
                    }
                    if timerValue == 0 {
                        sendLocalNotification()
                        dismiss()
                    }
                })
                .font(.system(size: 80))
            
            // show progress bar for the timer
            ProgressView(value: Double(initialValue - timerValue), total: Double(initialValue))
                .progressViewStyle(GradientProgressViewStyle())
                    .scaleEffect(x: 1, y: 4, anchor: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(height: 20)
                    .padding()
            
            Spacer()
            
            // buttons to handle adding time to timer
            addTimeToTimerView
                .foregroundStyle(.orange)

            Spacer()
            
            Button {
                timerValue = initialValue
                dismiss()
            } label: {
                Text("Skip rest")
            }
            .buttonStyle(CTAButton())
            .accessibilityLabel("Skip rest button")
        }
        .padding()
    }
    
    /// Function to send local notification when app is in foreground
    func sendLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time's up"
        content.body = "It's time to get back to work 💪"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    var addTimeToTimerView: some View {
        HStack {
            Button(action: {
                timerValue += 10
            }, label: {
                Text("+10s")
            })
            .padding()
            .buttonStyle(CTAButtonSmall())
            .accessibilityLabel("Add 10 seconds to timer button")
            
            Button(action: {
                timerValue += 20
            }, label: {
                Text("+20s")
            })
            .padding()
            .buttonStyle(CTAButtonSmall())
            .accessibilityLabel("Add 20 seconds to timer button")

            Button(action: {
                timerValue += 30
            }, label: {
                Text("+30s")
            })
            .padding()
            .buttonStyle(CTAButtonSmall())
            .accessibilityLabel("Add 30 seconds to timer button")

        }
    }
}
