//
//  LoginView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import SwiftUI

struct LoginView: View {
    
    // environment object to store the user view model
    @EnvironmentObject var userVM: UserViewModel
    @State var isLoading: Bool = false
    @State var isAuthenticatedAndConfirmedUser = false
    @State private var notification: InAppNotification? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                // add the logo
                Image("logo")
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .padding(.bottom)
                // add in two custom input fields
                InputField(data: $userVM.email, title: "Email").accessibilityLabel("Email input field")
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .accessibilityLabel("Email input field")
                InputField(data: $userVM.password, title: "Password").accessibilityLabel("Password input field")
                    .accessibilityLabel("Password input field")
                // add in the login button
                Button(action: {
                    authenticateUser()
                }, label: {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Login")
                    }
                }).buttonStyle(CTAButton())
                    .padding()
                    .accessibilityLabel("Login button")
                    .background {
                        NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), isActive: $userVM.isConfirmedEmailUser) {}
                    }
            }
            .inAppNotificationView(notification: $notification)
            .onAppear {
                if userVM.authenticationError {
                    notification = InAppNotification(style: .error, message: "Ooops, something went wrong authenticating you. Please try again later")
                }
            }
            
            // navigation links to reset password and sign up
            NavigationLink(destination: RequestPasswordResetView()) {
                Text("🔒 Forgot password? Let's reset it")
                    .tint(.secondary)
            }
            .padding(.bottom)
            NavigationLink(destination: RegistrationView()) {
                Text("Don't have an account? Sign up here")
                    .tint(.secondary)
            }
            .alert(isPresented: $userVM.authenticationError) {
                Alert(title: Text("Authentication Error"), message: Text("Invalid username or password"), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    /// func to authenticate user via API
    func authenticateUser() {
        isLoading = true
        userVM.logout()
        print("Login button pressed")
        userVM.authenticate() { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    Task.init {
                        userVM.fetchUser()
                    }
                case .failure:
                    print("Failed to auth user from LoginView")
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
