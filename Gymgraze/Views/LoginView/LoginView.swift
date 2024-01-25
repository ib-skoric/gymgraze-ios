//
//  LoginView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import SwiftUI

struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            Image("logo").resizable().frame(width: 150, height: 150)
            LoginInput(data: $email, title: "Email").accessibilityLabel("Email input field")
            LoginInput(data: $password, title: "Password").accessibilityLabel("Password input field")
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
