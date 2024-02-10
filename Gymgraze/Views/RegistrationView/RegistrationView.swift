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
    @State var weight: String = ""
    @State var height: String = ""

    struct Step {
        let question: String
        let placeholder: String
        let binding: Binding<String>
    }

    var steps: [Step] {
        [
            Step(question: "What's a good email to contact you on?", placeholder: "Email", binding: $email),
            Step(question: "Give us a password to keep your account safe and sound!", placeholder: "Password", binding: $password),
            Step(question: "What should we call you?", placeholder: "Name", binding: $name),
            Step(question: "What is your age?", placeholder: "Age", binding: $age),
            Step(question: "What is your current weight?", placeholder: "Weight", binding: $weight),
            Step(question: "What is your current height?", placeholder: "Height", binding: $height)
        ]
    }

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
        
        if step < steps.count {
            VStack {
                Text(steps[step].question)
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                
                InputField(data: steps[step].binding, title: steps[step].placeholder)
                    .accessibilityLabel("\(steps[step].placeholder) input field")
            }
            .transition(.push(from: .trailing))
        } else {
            VStack {
                Text("That's all!\n\n Ready?\n Hit the button below and let's go! 🚀")
                    .multilineTextAlignment(.center)
                    .font(.headline)
            }
            .transition(.push(from: .trailing))
        }
        
        Spacer()
        
        if step < steps.count {
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
                withAnimation {
                    step += 1
                }
            }, label: {
                Text("Sign up")
            }).buttonStyle(CTAButton())
                .padding()
                .accessibilityLabel("Sign up button")
        }
    }
}


#Preview {
    RegistrationView()
}
