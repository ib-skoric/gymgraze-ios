//
//  RegistrationViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 11/02/2024.
//

import Foundation
import SwiftUI

/// ViewModel for managing the registration process of a new user
class RegistrationViewModel: ObservableObject {
    
    // ----- Variables -----
    @Published var isRegistrationSuccessful: Bool = false
    var registration: Registration?
    
    /// Method used for registering a new user via Rails back end.
    /// - Parameter registration: registration object containing the user's data
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
