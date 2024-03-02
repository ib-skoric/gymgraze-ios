//
//  RegistrationConfirmEmailView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 15/02/2024.
//

import SwiftUI

/// View used to comfirm users email address
struct RegistrationConfirmEmailView: View {
    
    // ---- Variables
    @State var emailConfirmation: String = ""
    @State private var isResendEmailButtonDisabled = true
    @State private var countdownTimer = 60
    var email: String = ""
    
    @EnvironmentObject var userVM: UserViewModel
    @ObservedObject var registrationVM =  RegistrationViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Thank you for signing up!")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("We will just need to confirm your email...")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top)
            
            Spacer()
            
            Text("Head over to your email address \(userVM.user?.email ?? "") and copy the confirmation code here 👇")
                .multilineTextAlignment(.center)
            
            InputField(data: $emailConfirmation, title: "Email confirmation code")
            
            Button(action: {
                if !isResendEmailButtonDisabled {
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
            }, label: {
                Text("Confirm email")
            }).buttonStyle(CTAButton())
                .padding()
                .accessibilityLabel("Confirm email")
                .navigationDestination(isPresented: $registrationVM.isEmailConfirmationSuccessful, destination: {
                    SetGoalsView().navigationBarBackButtonHidden(true)
                })
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
    RegistrationConfirmEmailView()
}
