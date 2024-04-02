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
    @StateObject var diaryVM = DiaryViewModel()
    
    var body: some Scene {
        
        WindowGroup {
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
        }
        
    }
}

