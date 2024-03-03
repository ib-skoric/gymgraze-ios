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
    @Published var hasSetGoals = false
    
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
    
    func setGoal(goal: GoalPayload, completion: @escaping (Result<String, Error>) -> Void) {
        UserService().setGoal(goal: goal) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let email):
                    self.hasSetGoals = true
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
}
