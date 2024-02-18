//
//  ContentView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                Button(action: { print("Get email status button tapped") }) {
                    Text("Check email status")
                }
                Button(action: {
                    loginVM.logout()
                }) {
                    Text("Logout")
                }
            }.padding()
        }
    }
}

#Preview {
    MainView()
}

