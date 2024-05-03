//
//  InAppNotificationModifier.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 03/05/2024.
//

import Foundation
import SwiftUI

struct InAppNotificationModifier: ViewModifier {
    
    @Binding var notification: InAppNotification?
    @State private var dispatchWorkItem: DispatchWorkItem?
    
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
    
    private func showNotification() {
        guard let notification = notification else { return }
        
        UIImpactFeedbackGenerator(style: .light)
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
    
    private func dismissNotification() {
        withAnimation {
            notification = nil
        }
        
        dispatchWorkItem?.cancel()
        dispatchWorkItem = nil
    }
}

extension View {
    func inAppNotificationView(notification: Binding<InAppNotification?>) -> some View {
        self.modifier(InAppNotificationModifier(notification: notification))
    }
}
