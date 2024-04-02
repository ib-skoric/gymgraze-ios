//
//  GymgrazeApp.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import SwiftUI

@main
struct GymgrazeApp: App {
    @StateObject var userVM = UserViewModel()
    
    var body: some Scene {
        WindowGroup {
            if userVM.user != nil && userVM.isConfirmedEmailUser {
                ContentView()
                    .environmentObject(userVM)
                    .accentColor(Color(.orange))
            } else {
                LoginView()
                    .environmentObject(userVM)
                    .accentColor(Color(.orange))
            }
        }
        
    }
}

