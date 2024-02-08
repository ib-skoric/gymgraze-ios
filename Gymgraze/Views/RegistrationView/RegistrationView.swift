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
    @State var step: Int = 0
    
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
        
        Spacer()
        
        if step == 0 {
            
            VStack {
                Text("What's a good email to contact you on?")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                
                InputField(data: $email, title: "Email").accessibilityLabel("Email input field")
                
            }.transition(.push(from: .trailing))
            
            
        } else if step == 1 {
            
            VStack {
                Text("Give us a password to keep your account safe and sound!")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                
                InputField(data: $password, title: "Password").accessibilityLabel("Password input field")
            }.transition(.push(from: .trailing))
        } else if step == 2 {
            
            VStack {
                Text("What should we call you?")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                
                InputField(data: $name, title: "Name").accessibilityLabel("Name input field")
            }
            .transition(.push(from: .trailing))
        }
        
        
        Spacer()
        
        if step != 2 {
            Button(action: {
                print("Next button pressed for step \(step)")
                withAnimation {
                    step += 1
                }
            }, label: {
                Text("Next")
            }).buttonStyle(CTAButton())
                .padding()
                .accessibilityLabel("Next step button")
        } else {
            Button(action: {
                print("Sign up button pressed")
            }, label: {
                Text("Sign up!")
            }).buttonStyle(CTAButton())
                .padding()
                .accessibilityLabel("Sign up button")
        }
    }
}

#Preview {
    RegistrationView()
}
