//
//  UserViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 15/02/2024.
//

import Foundation

class UserViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var isConfirmedEmailUser: Bool = false
    @Published var hasSuccessfullyRequestedPasswordReset = false
    
    init() {
        print("Attempting to fetch user inside init method")
        fetchUser()
    }
    
    func fetchUser() {
        self.isLoading = true
        UserService().fetchUser { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                    self.isConfirmedEmailUser = self.checkEmailConfirmed()
                    print(user)
                    self.isLoading = false
                case .failure(let error):
                    print("Error fetching user: \(error)")
                    self.isLoading = false
                }
            }
        }
    }
    
    func checkEmailConfirmed() -> Bool {
        return user?.confirmed_at != nil
    }
    
    func requestPasswordRest(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        UserService().requestPasswordReset(email: email) { (result) in
          DispatchQueue.main.async {
          switch result {
            case .success(let string):
              self.hasSuccessfullyRequestedPasswordReset = true
              completion(.success(true))
            case .failure(let error):
              print("Oops something went wrong requesting password reset email: \(error)")
              completion(.failure(error))
          }
        }
        }
    }
}
