//
//  LoginViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import Foundation

/// ViewModel used for managing the login process and authentication 
class LoginViewModel: ObservableObject {
    
    @Published var isLoading = false
    
    init () {
        checkAuthStatus()
    }
    
    // ----- Variables -----
    var email: String = ""
    var password: String = ""
    @Published var authenticated: Bool = getToken() != nil
    @Published var userLoggedOut: Bool = false
    @Published var authenticationError: Bool = false
    
    func checkAuthStatus() {
        self.isLoading = true
        
        if getToken() != nil {
            self.authenticated = true
            print("LoginVM model method was able to auth user correctly")
            self.isLoading = false
        } else {
            self.isLoading = false
            print("LoginVM model method was NOT able to auth user correctly")
        }
    }
}
