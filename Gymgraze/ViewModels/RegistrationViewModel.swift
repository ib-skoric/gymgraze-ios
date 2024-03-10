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
    @Published var isEmailConfirmationSuccessful: Bool = false
    @Published var emailConfirmationError: Bool = false
    var registration: Registration?

        
    func confirmEmail(confirmationToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        RegistrationService().confirmEmail(confirmationToken: confirmationToken) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let emailConfirmedTimestamp):
                    self.isEmailConfirmationSuccessful = true
                    completion(.success(emailConfirmedTimestamp))
                case .failure(let error):
                    self.emailConfirmationError = true
                    print("Oops something went wrong inside RegistrationViewModel: \(error)")
                }
            }
        }
    }
}
