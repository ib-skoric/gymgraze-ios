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
                // TODO: Add an action
            }, label: {
                Text("Reset password")
            }).buttonStyle(CTAButton())
                .padding()
                .accessibilityLabel("Confirm email")
                .navigationDestination(isPresented: $passwordResetSuccessful, destination: {
                    ContentView().navigationBarBackButtonHidden(true)
                })
        }
    }
    
    func resetPassword() {
        // TODO: Add logic here
    }
}

#Preview {
    ResetPasswordView()
}
