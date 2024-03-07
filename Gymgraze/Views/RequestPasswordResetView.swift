//
//  PasswordResetView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 02/03/2024.
//

import SwiftUI

struct RequestPasswordResetView: View {
    
    @State var passwordResetEmail: String = ""
    @State var isLoading = false
    @State var hasErrorSendingEmail = false
    
    @EnvironmentObject var userVM: UserViewModel
    
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
                requestPasswordReset()
            }, label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Send password reset code")
                }
            }).buttonStyle(CTAButton())
                .padding()
                .accessibilityLabel("Send password reset code button")
                .alert(isPresented: $hasErrorSendingEmail) {
                    Alert(title: Text("Error sending email"), message: Text("Something's gone wrong."), dismissButton: .default(Text("Dismiss")))
                }
        }
    }
    
    func requestPasswordReset() {
        // TODO: Add logic here
        isLoading = true
        userVM.requestPasswordRest(email: passwordResetEmail) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("Email sent sucessfully")
                case .failure(_):
                    print("Something went wrong")
                    hasErrorSendingEmail = true
                }
            }
        }
    }
}

#Preview {
    RequestPasswordResetView()
}
