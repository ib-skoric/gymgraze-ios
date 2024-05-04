//
//  AddToFoodDiaryViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 23/03/2024.
//

import Foundation

class AddToFoodDiaryViewModel: ObservableObject {
    
    /// Published properties used by different views to update UI
    @Published var foodItems: [FoodItem.Product] = []
    @Published var isLoading: Bool = false
    @Published var searchCompleted: Bool = false
    
    /// Method for searching for food items
    func searchForFood(searchTerm: String) {
        self.isLoading = true
        
        // call the API service to search for food items
        OpenFoodFactsService().searchForFood(searchTerm: searchTerm) { result in
            switch result {
            case .success(let foodItems):
                self.foodItems = foodItems
                self.searchCompleted = true
            case .failure(let error):
                print(error)
            }
            self.isLoading = false
        }
    }
}
