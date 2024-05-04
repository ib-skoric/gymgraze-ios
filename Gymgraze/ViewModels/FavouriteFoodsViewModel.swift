//
//  FavouriteFoodsViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 27/04/2024.
//

import Foundation
import SwiftUI

class FavouriteFoodsViewModel: ObservableObject {
    
    /// Published properties used by different views to update UI
    @Published var favouriteFoodsIds: [String] = []
    @Published var favouriteFoods: [FoodItem.Product] = []
    @Published var isLoading: Bool = false
    
    // User Defaults
    private let userDefaults = UserDefaults.standard
    
    /// Initialiser - fetches favourite foods from user defaults
    init() {
        favouriteFoodsIds = self.userDefaults.stringArray(forKey: "favouriteFoodsIds") ?? []
        if let favouriteFoodsData = userDefaults.object(forKey: "favouriteFoods") as? Data {
            do {
                favouriteFoods = try JSONDecoder().decode([FoodItem.Product].self, from: favouriteFoodsData)
            } catch {
                print("Error decoding favourite foods: \(error)")
            }
        }
    }

    /// Method for handling favourite foods (removing and setting)
    func handleFavourite(foodId: String) {
        withAnimation {
            self.isLoading = true
        }
    
        // if the food is already in favourites, remove it
        if favouriteFoodsIds.contains(foodId) || favouriteFoods.contains(where: { $0.id == foodId }) {
            let index = favouriteFoodsIds.firstIndex(of: foodId)
            favouriteFoodsIds.remove(at: index!)
            let foodIndex = favouriteFoods.firstIndex { $0.id == foodId }
            favouriteFoods.remove(at: foodIndex!)
            self.isLoading = false
        } else {
            // else add it
            favouriteFoodsIds.append(foodId)
            var foodItem = FoodItem.Product()
            
            // Fetch the actual food from the API
            OpenFoodFactsService().fetchFoodItem(barcode: foodId) { result in
                switch result {
                case .success(let food):
                    foodItem = food.product
                    self.favouriteFoods.append(foodItem)
                    // set it to user defaults
                    let favouriteFoodsData = try? JSONEncoder().encode(self.favouriteFoods)
                    self.userDefaults.set(favouriteFoodsData, forKey: "favouriteFoods")
                case .failure(let error):
                    print("Error fetching food item: \(error)")
                }
                self.isLoading = false
            }
        }
        
        // set the value in user defaults
        userDefaults.set(favouriteFoodsIds, forKey: "favouriteFoodsIds")
        print("Favourite foods: \(favouriteFoodsIds)")
    }
}
