//
//  UserViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 15/02/2024.
//

import Foundation

class UserViewModel: ObservableObject {
    
    @Published var user: User?
    
    init() {
        fetchUser()
    }
    
    func fetchUser() {
        UserService().fetchUser { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    print("Error fetching user: \(error)")
                }
            }
        }
    }
    
    func checkEmailConfirmed() -> Bool {
        return user?.confirmed_at != nil
    }
}
