//
//  RegistrationView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 08/02/2024.
//

import SwiftUI

struct RegistrationView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var name: String = ""
    
    var body: some View {
        VStack {
            Text("Join us!")
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.bold)
            
            Text("Create an account to get started")
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.top)
        
        ScrollView {
            InputField(data: $email, title: "Email").accessibilityLabel("Email input field")
            
            InputField(data: $password, title: "Password").accessibilityLabel("Password input field")
            
            InputField(data: $name, title: "Name").accessibilityLabel("Name input field")
        }
        Button(action: {
            print("Registration button pressed")
        }, label: {
            Text("Sign up")
        }).buttonStyle(CTAButton())
            .padding()
            .accessibilityLabel("Sign up button")
    }
}

#Preview {
    RegistrationView()
}
