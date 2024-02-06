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
                print(token)
            case .failure(let error):
                // if the login failed, print the error
                print(error)
            }
        }
    }
}
