//
//  RegistrationConfirmEmailView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 15/02/2024.
//

import SwiftUI

/// View used to comfirm users email address
struct ConfirmationCodeInputView: View {
    
    // ---- Variables
    @State var token: String = ""
    @State private var isResendEmailButtonDisabled = true
    @State private var countdownTimer = 60
    @State private var tokenConfirmedSuccessfully = false
    @State private var emailConfirmed = false
    @State private var emailConfirmationError = false
    
    var confirmationType: String
    
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
        // compute headings based on whether this is email confirmation of password reset view
        let heading: String = (confirmationType == "email") ? "Thank you for signing up!" : "Your password has been reset"
        let subheading: String = (confirmationType == "email") ? "We will just need to confirm your email..." : "We'll just need a code to confirm this..."
        
        NavigationStack {
            VStack {
                Text(heading)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(subheading)
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            
            Spacer()
            
            Text("Head over to your email address and copy the confirmation code here 👇")
                .multilineTextAlignment(.center)
                .padding()
            
            InputField(data: $token, title: "Email confirmation code")
                .accessibilityLabel("Email confirmation code input field")
            
            if confirmationType == "email" {
                Button(action: {
                    if !isResendEmailButtonDisabled{
                        resendConfirmationEmail()
                    }
                },
                       label: {
                    Text(isResendEmailButtonDisabled ? "Resend email in \(countdownTimer) seconds" : "Resend email")
                        .disabled(isResendEmailButtonDisabled)
                })
                .onAppear() {
                    startCountdown()
                }
            }
            
            Spacer()
            Button(action: {
                if confirmationType == "email" {
                    validateCodeAndConfirmEmail()
                } else {
                    validatePasswordReset()
                }
            }, label: {
                if confirmationType == "email" {
                    Text("Confirm email")
                } else {
                    Text("Confirm password reset")
                }
            }).buttonStyle(CTAButton())
                .padding()
                .accessibilityLabel("Confirm email button")
                .background {
                    if confirmationType == "email" {
                        NavigationLink(destination: SetGoalsView().navigationBarBackButtonHidden(true), isActive: self.$emailConfirmed) {}
                    } else {
                        NavigationLink(destination: ResetPasswordView(token: token).navigationBarBackButtonHidden(true), isActive: self.$tokenConfirmedSuccessfully) {}
                    }
                }
                .alert(isPresented: self.$emailConfirmationError) {
                    Alert(title: Text("Email confirmation error"), message: Text("The confirmation code inputted is not correct, please try again."), dismissButton: .default(Text("OK")))
                }
        }
    }
    
    /// func that starts the countdown for re-sending emails
    func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            countdownTimer -= 1
            
            if countdownTimer == 0 {
                timer.invalidate()
                isResendEmailButtonDisabled = false
            }
        }
    }
    
    /// function that handles validating code and confirming email
    func validateCodeAndConfirmEmail() {
        RegistrationService().confirmEmail(confirmationToken: token) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let emailConfirmedTimestamp):
                    self.emailConfirmed = true
                    userVM.user?.confirmedAt = emailConfirmedTimestamp
                case .failure(let error):
                    self.emailConfirmationError = true
                    print(error)
                }
            }
        }
    }
    
    /// function that handles resending the email after time interval expired
    func resendConfirmationEmail() {
        RegistrationService().resendEmailConfirmation() {
            (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("yaaay")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    /// function that handles validatiing password reset (as this view is re-used)
    func validatePasswordReset() {
        UserService().validatePasswordResetCode(token: token) {
            (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    tokenConfirmedSuccessfully = true
                    print("yaaay")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}


#Preview {
    ConfirmationCodeInputView(confirmationType: "password").environmentObject(UserViewModel())
}
