//
//  LoginView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import SwiftUI

struct LoginView: View {
    
    // environment object to store the login view model
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var userVM: UserViewModel
    
    @State var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
                VStack {
                    // add the logo
                    Image("logo").resizable().frame(width: 150, height: 150)
                    // add in two custom input fields
                    InputField(data: $loginVM.email, title: "Email").accessibilityLabel("Email input field")
                    InputField(data: $loginVM.password, title: "Password").accessibilityLabel("Password input field")
                    // add in the login button
                    Button(action: {
                        isLoading = true
                        loginVM.logout()
                        print("Login button pressed")
                        loginVM.authenticate() { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success:
                                    userVM.fetchUser()
                                    
                                case .failure:
                                    print("Failed to auth user from LoginView")
                                }
                            }
                        }
                        
                    }, label: {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Login")
                        }
                    }).buttonStyle(CTAButton())
                        .padding()
                        .accessibilityLabel("Login button")
                        .navigationDestination(isPresented: $loginVM.authenticated) {
                            ContentView().navigationBarBackButtonHidden(true)
                        }
                }
                NavigationLink(destination: RegistrationView()) {
                    Text("Don't have an account? Sign up here")
                        .tint(.secondary)
                }
                .alert(isPresented: $loginVM.authenticationError) {
                    Alert(title: Text("Authentication Error"), message: Text("Invalid username or password"), dismissButton: .default(Text("OK")))
                }
            }
        }
    }

#Preview {
    LoginView()
}
