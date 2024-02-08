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
    @State var age: String = ""
    
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
        } else if step == 3 {
            VStack {
                Text("What is your age?")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                
                InputField(data: $age, title: "Age").accessibilityLabel("Age input field")
            }
            .transition(.push(from: .trailing))
        } else if step == 4 {
            VStack {
                Text("What is your current weight?")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                
                InputField(data: $age, title: "Weight").accessibilityLabel("Weight input field")
            }
            .transition(.push(from: .trailing))
        } else if step == 5 {
            VStack {
                Text("What is your current height?")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                
                InputField(data: $age, title: "Height").accessibilityLabel("Height input field")
            }
            .transition(.push(from: .trailing))
        } else {
            VStack {
                Text("Thank you for signing up!")
                    .multilineTextAlignment(.center)
                    .font(.headline)
            }
            .transition(.push(from: .trailing))
        }
        
        
        Spacer()
        
        if step <= 4  {
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
        } else if step == 5 {
            Button(action: {
                print("Sign up button pressed")
                withAnimation {
                    step += 1
                }
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
