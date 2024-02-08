//
//  LoginViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    var username: String = ""
    var password: String = ""
    @Published var authenticated: Bool = false
    @Published var authenticationError: Bool = false
    
    func authenticate() {
        // use webservice to authenticate the user
        WebService().authenticate(username: username, password: password) { (result) in
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
                    }
                    self.authenticated = true
                    self.authenticationError = false
                case .failure(let error):
                    print("Error authenticating: \(error)")
                    self.authenticationError = true
                }
            }
        }
    }
}
