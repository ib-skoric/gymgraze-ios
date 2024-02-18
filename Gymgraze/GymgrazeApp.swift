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
            if loginVM.authenticated {
                MainView()
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

