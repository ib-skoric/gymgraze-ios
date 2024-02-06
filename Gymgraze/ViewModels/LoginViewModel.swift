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
    
    func authenticate() {
        // use webservice to authenticate the user
        WebService().authenticate(username: username, password: password) { (result) in
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
            case .failure(let error):
                // if the login failed, print the error
                print(error)
            }
        }
    }
}
