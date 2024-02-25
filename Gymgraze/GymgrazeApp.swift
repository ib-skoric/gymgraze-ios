//
//  GymgrazeApp.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import SwiftUI

@main
struct GymgrazeApp: App {
    @StateObject var loginVM = LoginViewModel()
    @StateObject var userVM = UserViewModel()
    
    var body: some Scene {
        WindowGroup {
            // check if token exists
            if loginVM.isLoading || userVM.isLoading {
                ProgressView()
            } else if loginVM.authenticated && userVM.user?.confirmed_at != nil {
                ContentView()
                    .environmentObject(loginVM)
                    .environmentObject(userVM)
            } else if loginVM.authenticated  {
                RegistrationConfirmEmailView()
                    .environmentObject(loginVM)
                    .environmentObject(userVM)
            } else {
                LoginView()
                    .environmentObject(loginVM)
                    .environmentObject(userVM)
            }
        }
    }
}

