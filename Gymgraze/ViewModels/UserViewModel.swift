//
//  UserViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 15/02/2024.
//

import Foundation

class UserViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var authenticated: Bool = false
    @Published var authenticationError: Bool = false
    @Published var isLoading: Bool = false
    @Published var isConfirmedEmailUser: Bool = false
    @Published var hasSuccessfullyRequestedPasswordReset = false
    @Published var hasSetGoals = false
    
    init() {
        print("Attempting to fetch user inside init method")
        fetchUser()
    }
    
    /// Method used for setting the user as authenticated
    func authenticate(completion: @escaping (Result<Bool, APIError>) -> Void) {
        DispatchQueue.main.async {
            // getAndSetTokenInKeychain returns a closure which we check
            getAndSetTokenInKeychain(email: self.email, password: self.password) { result in
                switch result {
                    // if we're able to get and set the token successfully
                case .success:
                    // make the user authenticated
                    self.authenticated = true
                    completion(.success(true))
                case .failure:
                    self.authenticationError = true
                    completion(.failure(APIError.invalidCredentials))
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
            self.user = nil
        } else {
            print("Failed to remove token")
        }
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
    
    func setGoal(goal: GoalPayload, completion: @escaping (Result<String, Error>) -> Void) {
        UserService().setGoal(goal: goal) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let goal):
                    self.hasSetGoals = true
                    self.user?.goal = goal
                    completion(.success("Goal set successfully"))
                case .failure(let error):
                    print("Oops something went wrong \(error)")
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
