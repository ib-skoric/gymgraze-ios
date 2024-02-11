//
//  RegistrationViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 11/02/2024.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    
    var registration: Registration?
    
    func register(registration: Registration) {
        WebService().register(registration: registration) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let email):
                    print("User with email: \(email) was registered correctly")
                case .failure(let error):
                    print("Oops something went wrong \(error)")
                }
            }
        }
        
    }
}
