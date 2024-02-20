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
    var email: String = ""
    
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
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
        
        Text("Head over to your email address: \(email) and copy the confirmation code here 👇")
            .multilineTextAlignment(.center)
        
        InputField(data: $emailConfirmation, title: "Email confirmation code")
        Spacer()
        Button(action: {
            userVM.fetchUser()
            print("Current email auth status \(userVM.user?.confirmed_at ?? "no data")")
            print("Email confirmation button tapped")
        }, label: {
            Text("Confirm email")
        }).buttonStyle(CTAButton())
            .padding()
            .accessibilityLabel("Confirm email")
    }
}

#Preview {
    RegistrationConfirmEmailView()
}
