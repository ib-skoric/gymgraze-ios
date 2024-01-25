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
    
    var body: some View {
        VStack {
            // add the logo
            Image("logo").resizable().frame(width: 150, height: 150)
            // add in two custom input fields
            LoginInput(data: $email, title: "Email").accessibilityLabel("Email input field")
            LoginInput(data: $password, title: "Password").accessibilityLabel("Password input field")
            // add in the login button
            Button(action: {
                print("Login button pressed")
            }, label: {
                Text("Login")
            }).buttonStyle(LoginButton())
                .padding()
        }
    }
}

#Preview {
    LoginView()
}
