//
//  PasswordResetView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 02/03/2024.
//

import SwiftUI

struct PasswordResetView: View {
    
    @State var passwordResetEmail: String = ""
    @State var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Reset your password")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("It happens to everyone, no worries!")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top)
            
            Spacer()
            
            Text("What's the email your account was registered with?")
                .multilineTextAlignment(.center)
                .padding()
            
            InputField(data: $passwordResetEmail, title: "Your email")
            
            Spacer()
            Button(action: {
                // TODO: Add logic here
            }, label: {
                if isLoading {
                    ProfileView()
                } else {
                    Text("Send password reset code")
                }
            }).buttonStyle(CTAButton())
                .padding()
                .accessibilityLabel("Send password reset code button")
        }
    }
    }

#Preview {
    PasswordResetView()
}
