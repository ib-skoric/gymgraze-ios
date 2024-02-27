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
    
    init() {
        fetchUser()
    }
    
    func fetchUser() {
        self.isLoading = true
        UserService().fetchUser { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
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
}
