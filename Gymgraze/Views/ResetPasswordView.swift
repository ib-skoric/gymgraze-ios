//
//  ResetPasswordView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 07/03/2024.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @State private var newPassword: String = ""
    @State private var newPasswordConfirm: String = ""
    @State private var passwordResetSuccessful = false
    @State private var hasErrorsResettingPassword = false
    var token: String 
    
    var body: some View {
        NavigationStack {
            // Main Vstack
            VStack {
                Text("Nice, thank you!")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.bold)
                Text("Please input your new password")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top)
            
            Spacer()
            
            InputField(data: $newPassword, title: "Your new password")
            InputField(data: $newPasswordConfirm, title: "Confirm your new password")
            
            Spacer()
            
            Button(action: {
                validatePasswordsMatch()
                resetPassword(token: token, password: newPassword)
            }, label: {
                Text("Reset password")
            }).buttonStyle(CTAButton())
                .padding()
                .accessibilityLabel("Confirm email")
                .navigationDestination(isPresented: $passwordResetSuccessful, destination: {
                    LoginView().navigationBarBackButtonHidden(true)
                })
                .alert(isPresented: self.$hasErrorsResettingPassword) {
                    Alert(title: Text("Email confirmation error"), message: Text("Inputted passwords don't match or there was an error processing your request"), dismissButton: .default(Text("OK")))
                }
        }
    }
    
    func validatePasswordsMatch() {
        if newPassword != newPasswordConfirm {
            self.hasErrorsResettingPassword = true
        }
    }
    
    func resetPassword(token: String, password: String) {
        UserService().resetPsasword(token: token, password: password) {
            (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    passwordResetSuccessful = true
                    print("yaaay")
                case .failure(let error):
                    hasErrorsResettingPassword = true
                    print(error)
                }
            }
        }
    }

}

#Preview {
    ResetPasswordView(token: "jsadkajdkas")
}
