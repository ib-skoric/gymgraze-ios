//
//  PasswordResetView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 02/03/2024.
//

import SwiftUI

struct RequestPasswordResetView: View {
    
    // state and env variables to handle view updates
    @State var passwordResetEmail: String = ""
    @State var isLoading = false
    @State var hasErrorSendingEmail = false
    @State var emailSentSuccessfully = false
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
        NavigationStack {
            viewHeading
                .padding(.top)
            
            Spacer()
            
            Text("What's the email your account was registered with?")
                .multilineTextAlignment(.center)
                .padding()
            
            InputField(data: $passwordResetEmail, title: "Your email")
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .accessibilityLabel("Email input field")
            
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
                .background {
                    NavigationLink(destination: ConfirmationCodeInputView(confirmationType: "password").navigationBarBackButtonHidden(true), isActive: $emailSentSuccessfully) {}
                }
                .accessibilityLabel("Send password reset code button")
                .alert(isPresented: $hasErrorSendingEmail) {
                    Alert(title: Text("Error sending email"), message: Text("Something's gone wrong."), dismissButton: .default(Text("Dismiss")))
                }
        }
    }
    
    /// func to send password reset email
    func requestPasswordReset() {
        isLoading = true
        userVM.requestPasswordRest(email: passwordResetEmail) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("Email sent sucessfully")
                    withAnimation {
                        isLoading = false
                        emailSentSuccessfully = true
                    }
                case .failure(_):
                    print("Something went wrong")
                    hasErrorSendingEmail = true
                }
            }
        }
    }
    
    var viewHeading: some View {
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
    }
}

#Preview {
    RequestPasswordResetView()
}
