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
    @Published var isConfirmedEmailUser: Bool = false
    @Published var hasSuccessfullyRequestedPasswordReset = false
    @Published var hasSetGoals = false
    @Published var isLoading: Bool = true
    
    private let cache = InMemoryCache<User>(expirationInterval: 1 * 60)
    
    init() {
        fetchUser()
    }
    
    func reset() {
        user = nil
        email = ""
        password = ""
        authenticated = false
        authenticationError = false
        isConfirmedEmailUser = false
        hasSuccessfullyRequestedPasswordReset = false
        hasSetGoals = false
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
            self.reset()
        } else {
            print("Failed to remove token")
        }
    }
    
    func fetchUser() {
        self.authenticationError = false
        self.isLoading = true
        UserService().fetchUser { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    // set the user data to the property
                    self.user = user
                    self.user?.meals = user.meals
                    // check if email is confirmed
                    self.isConfirmedEmailUser = self.checkEmailConfirmed()
                    // print the user
                    print(user)
                    // stop the loading
                case .failure(let error):
                    self.authenticationError = true
                    print("Error fetching user: \(error)")
                }
                self.isLoading = false
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
        return user?.confirmedAt != nil
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
    
    func updatePersonalDetails(name: String, age: Int, height: Int, completion: @escaping (Result<String, Error>) -> Void) {
        
        let personalDetails = PersonalDetails(name: name, age: age, height: height)
        
        UserService().updatePersonalDetails(personalDetails: personalDetails) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                    completion(.success("User updated successfully"))
                case .failure(let error):
                    print("Oops something went wrong updating user: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func updateGoals(goal: GoalPayload, completion: @escaping (Result<String, Error>) -> Void) {
        
        print("Goal: ", goal)
        
        UserService().setGoal(goal: goal) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let goal):
                    self.user?.goal = goal
                    completion(.success("Goal updated successfully"))
                case .failure(let error):
                    print("Oops something went wrong updating goal: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func updateMeals(meals: [MealToAPI], completion: @escaping (Result<String, Error>) -> Void) {
        UserService().updateMeals(meals: meals) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let meals):
                    self.user?.meals = meals
                    completion(.success("Meals updated successfully"))
                case .failure(let error):
                    print("Oops something went wrong updating meals: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deleteMeal(id: Int, completion: @escaping (Result<String, Error>) -> Void) {
        UserService().deleteMeal(id: id) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let status):
                    completion(.success("Meal deleted successfully"))
                case .failure(let error):
                    print("Oops something went wrong deleting meal: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
}
