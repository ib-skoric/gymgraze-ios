//
//  RegistrationViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 11/02/2024.
//

import Foundation
import SwiftUI

class RegistrationViewModel: ObservableObject {
    
    @Published var isRegistrationSuccessful: Bool = false
    var registration: Registration?
    
    func register(registration: Registration) {
        RegistrationService().register(registration: registration) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let email):
                    print("User with email: \(email) was registered correctly")
                    self.isRegistrationSuccessful = true
                case .failure(let error):
                    print("Oops something went wrong \(error)")
                }
            }
        }
        
    }
}
