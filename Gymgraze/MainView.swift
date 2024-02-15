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
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                Button(action: { getEmailStatus() }) {
                    Text("Check email status")
                }
                Button(action: {
                    loginVM.logout()
                }) {
                    Text("Logout")
                }
            }.padding()
        }
        .navigationDestination(isPresented: $loginVM.authenticated) {
            LoginView()
        }
    }
    
    func getEmailStatus() {
        AuthenticationService().checkEmailConfirmed() { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let emailConfirmed):
                    if emailConfirmed != nil {
                        print("Email confirmed")
                    } else {
                        print("Email not confirmed")
                    }
                case .failure(let error):
                    print("Error checking email status: \(error)")
                }
            }
        }
    }
}

#Preview {
        MainView()
}

