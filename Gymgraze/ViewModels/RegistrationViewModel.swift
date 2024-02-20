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
    @Published var hasEmailConfirmed: Bool = false
    var registration: Registration?
    
    /// Method used for registering a new user via Rails back end.
    /// - Parameter registration: registration object containing the user's data
    func register(registration: Registration, completion: @escaping (Result<String, Error>) -> Void) {
        RegistrationService().register(registration: registration) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let email):
                    print("User with email: \(email) was registered correctly")
                    self.isRegistrationSuccessful = true
                    // returns completion for the "register" method so that we can proceed
                    // with auth the user
                    completion(.success(email))
                case .failure(let error):
                    print("Oops something went wrong \(error)")
                }
            }
        }
    }
    
    func confirmEmail(confirmationCode: String, completion: @escaping (Result<String, Error>) -> Void) {
        RegistrationService().confirmEmail(confirmationCode: confirmationCode) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let email):
                    print("User with email: \(email) was confirmed correctly")
                    self.hasEmailConfirmed = true
                    completion(.success(email))
                case .failure(let error):
                    print("Oops something went wrong \(error)")
                }
            }
        }
    }
}
