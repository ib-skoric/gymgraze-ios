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
    @State var emailConfirmation: String = ""
    @State private var isResendEmailButtonDisabled = true
    @State private var countdownTimer = 60
//    var email: String = ""
    var confirmationType: String
    
    @EnvironmentObject var userVM: UserViewModel
    @ObservedObject var registrationVM =  RegistrationViewModel()
    
    var body: some View {
        var heading: String = (confirmationType == "email") ? "Thank you for signing up!" : "Your password has been reset"
        var subheading: String = (confirmationType == "email") ? "We will just need to confirm your email..." : "We'll just need a code to confirm this..."
        
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
            
            Text("Head over to your email address: \(userVM.user?.email ?? "") and copy the confirmation code here 👇")
                .multilineTextAlignment(.center)
                .padding()
            
            InputField(data: $emailConfirmation, title: "Email confirmation code")
            
            Button(action: {
                if !isResendEmailButtonDisabled && confirmationType == "email" {
                    RegistrationService().resendEmailConfirmation() {
                        (result) in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                print("yaaay")
                            case .failure(let error):
                                print("Oops something went wrong inside RegistrationConfirmEmailView: \(error)")
                            }
                        }
                    }
                } else {
                    // TODO: Logic for validating resetting password code
                }
            },
                   label: {
                Text(isResendEmailButtonDisabled ? "Resend email in \(countdownTimer) seconds" : "Resend email")
                .disabled(isResendEmailButtonDisabled)
            })
            .onAppear() {
                startCountdown()
            }
            
            Spacer()
            Button(action: {
                if confirmationType == "email" {
                    registrationVM.confirmEmail(confirmationToken: emailConfirmation) { (result) in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let emailConfirmedTimestamp):
                                userVM.user?.confirmed_at = emailConfirmedTimestamp
                            case .failure(let error):
                                print("Oops something went wrong inside RegistrationConfirmEmailView: \(error)")
                            }
                        }
                    }
                } else {
                    // TODO: Logic for confirming password reset
                }
            }, label: {
                Text("Confirm email")
            }).buttonStyle(CTAButton())
                .padding()
                .accessibilityLabel("Confirm email")
                .navigationDestination(isPresented: $registrationVM.isEmailConfirmationSuccessful, destination: {
                    SetGoalsView().navigationBarBackButtonHidden(true)
                })
               // TODO: Code for navigating to a password reset view
                .alert(isPresented: $registrationVM.emailConfirmationError) {
                    Alert(title: Text("Email confirmation error"), message: Text("The confirmation code inputted is not correct, please try again."), dismissButton: .default(Text("OK")))
                }
        }
    }
    
    func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            countdownTimer -= 1
            
            if countdownTimer == 0 {
                timer.invalidate()
                isResendEmailButtonDisabled = false
            }
        }
    }
}


#Preview {
    ConfirmationCodeInputView(confirmationType: "password").environmentObject(UserViewModel())
}
