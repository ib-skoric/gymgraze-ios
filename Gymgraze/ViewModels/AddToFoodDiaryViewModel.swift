//
//  AddToFoodDiaryViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 23/03/2024.
//

import Foundation

class AddToFoodDiaryViewModel: ObservableObject {
    
    @Published var foodItems: [FoodItem.Product] = []
    @Published var isLoading: Bool = false
    
    func searchForFood(searchTerm: String) {
        self.isLoading = true
        OpenFoodFactsService().searchForFood(searchTerm: searchTerm) { result in
            switch result {
            case .success(let foodItems):
                self.foodItems = foodItems
            case .failure(let error):
                print(error)
            }
            self.isLoading = false
        }
    }
}
