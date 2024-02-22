//
//  LoginViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import Foundation

/// ViewModel used for managing the login process and authentication 
class LoginViewModel: ObservableObject {
    
    init () {
        authenticated = getToken() != nil
    }
    
    // ----- Variables -----
    var email: String = ""
    var password: String = ""
    @Published var authenticated: Bool = getToken() != nil
    @Published var authenticationError: Bool = false
    
    /// Method used for getting and setting the token in the Keychain
    func getAndSetTokenInKeychain(completion: @escaping (Result<Bool, APIError>) -> Void) {
        // use webservice to authenticate the user
        AuthenticationService().authenticate(email: email, password: password) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    let tokenData = token.data(using: .utf8)!
                    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                                kSecAttrAccount as String: "token",
                                                kSecValueData as String: tokenData]
                    let status = SecItemAdd(query as CFDictionary, nil)
                    if status == errSecSuccess {
                        print("Token saved successfully")
                        completion(.success(true))
                    }
                case .failure(let error):
                    print("Error authenticating: \(error)")
                    completion(.failure(APIError.invalidCredentials))
                }
            }
        }
    }
    
    /// Method used for setting the user as authenticated
    func authenticate() {
        DispatchQueue.main.async {
            // getAndSetTokenInKeychain returns a closure which we check
            self.getAndSetTokenInKeychain() { result in
                switch result {
                    // if we're able to get and set the token successfully
                case .success:
                    // make the user authenticated
                    self.authenticated = true
                case .failure:
                    self.authenticationError = true
                }
            }
        }
    }
    
    /// Method for logging the user out of the app and destroying the token from the keychain.
    func logout() {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: "token"]
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("Token removed successfully")
            self.authenticated = false
        } else {
            print("Failed to remove token")
        }
    }
}
