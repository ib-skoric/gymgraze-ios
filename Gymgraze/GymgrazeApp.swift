//
//  GymgrazeApp.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import SwiftUI
import UserNotifications

@main
struct GymgrazeApp: App {
    @StateObject var userVM = UserViewModel()
    @StateObject var diaryVM = DiaryViewModel()
    
    @State private var isActive: Bool = false
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if self.isActive {
                    if getToken() != nil && userVM.isConfirmedEmailUser {
                        ContentView()
                            .environmentObject(userVM)
                            .environmentObject(diaryVM)
                            .accentColor(Color(.orange))
                    } else {
                        LoginView()
                            .environmentObject(userVM)
                            .accentColor(Color(.orange))
                    }
                } else {
                    // SplashView is your custom splash screen view
                    SplashScreen()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}


