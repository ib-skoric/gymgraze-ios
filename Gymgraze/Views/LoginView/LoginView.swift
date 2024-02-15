//
//  LoginView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import SwiftUI

struct LoginView: View {
    
    // add two state variables to store the email and password
    @State var email: String = ""
    @State var password: String = ""
    
    // environment object to store the login view model
    @EnvironmentObject var loginVM: LoginViewModel
    
    var body: some View {
        NavigationStack {
            if loginVM.authenticated {
                MainView()
            } else {
                VStack {
                    // add the logo
                    Image("logo").resizable().frame(width: 150, height: 150)
                    // add in two custom input fields
                    InputField(data: $loginVM.email, title: "Email").accessibilityLabel("Email input field")
                    InputField(data: $loginVM.password, title: "Password").accessibilityLabel("Password input field")
                    // add in the login button
                    Button(action: {
                        print("Login button pressed")
                        loginVM.authenticate()
                    }, label: {
                        Text("Login")
                    }).buttonStyle(CTAButton())
                        .padding()
                        .accessibilityLabel("Login button")
                }
                NavigationLink(destination: RegistrationView()) {
                    Text("Don't have an account? Sign up here")
                        .tint(.secondary)
                }
                .alert(isPresented: $loginVM.authenticationError) {
                    Alert(title: Text("Authentication Error"), message: Text("Invalid username or password"), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
