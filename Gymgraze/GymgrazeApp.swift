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
//           LoginView()
//                .environmentObject(loginVM)
//                .environmentObject(userVM)
            BarcodeScannerView()
        }
    }
}

