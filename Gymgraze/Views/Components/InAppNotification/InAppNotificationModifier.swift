//
//  InAppNotificationModifier.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 03/05/2024.
//

import Foundation
import SwiftUI

struct InAppNotificationModifier: ViewModifier {
    // state and env variables to handle view updates
    @Binding var notification: InAppNotification?
    @State private var dispatchWorkItem: DispatchWorkItem?
    
    // body content of the view
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainInAppNotificationView()
                        .offset(y: 50)
                }.animation(.spring(), value: notification)
            )
            .onChange(of: notification) { value in
                showNotification()
            }
    }
    
    // view to show in-app notification
    @ViewBuilder func mainInAppNotificationView() -> some View {
        if let notification = notification {
            VStack {
                InAppNotificationView(
                    style: notification.style,
                    message: notification.message,
                    width: notification.width
                ) {
                    dismissNotification()
                }
                Spacer()
            }
        }
    }
    
    // function to show notification
    private func showNotification() {
        guard let notification = notification else { return }
        
        UIImpactFeedbackGenerator(style: .medium)
            .impactOccurred()
        
        if notification.duration > 0 {
            dispatchWorkItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissNotification()
            }
            
            dispatchWorkItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + notification.duration, execute: task)
        }
    }
    
    // function to dismiss notification
    private func dismissNotification() {
        withAnimation {
            notification = nil
        }
        
        dispatchWorkItem?.cancel()
        dispatchWorkItem = nil
    }
}

// extension to add in-app notification view to the view
extension View {
    func inAppNotificationView(notification: Binding<InAppNotification?>) -> some View {
        self.modifier(InAppNotificationModifier(notification: notification))
    }
}
