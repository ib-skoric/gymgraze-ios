//
//  FavouriteFoodsViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 27/04/2024.
//

import Foundation

class FavouriteFoodsViewModel: ObservableObject {
    
    @Published var favouriteFoodsIds: [String] = []
    @Published var favouriteFoods: [FoodItem.Product] = []
    @Published var isLoading: Bool = false
    private let userDefaults = UserDefaults.standard
    
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

    
    func handleFavourite(foodId: String) {
        self.isLoading = true
        if favouriteFoodsIds.contains(foodId) || favouriteFoods.contains(where: { $0.id == foodId }) {
            let index = favouriteFoodsIds.firstIndex(of: foodId)
            favouriteFoodsIds.remove(at: index!)
            let foodIndex = favouriteFoods.firstIndex { $0.id == foodId }
            favouriteFoods.remove(at: foodIndex!)
            self.isLoading = false
        } else {
            favouriteFoodsIds.append(foodId)
            var foodItem = FoodItem.Product()
            
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
        
        userDefaults.set(favouriteFoodsIds, forKey: "favouriteFoodsIds")
        print("Favourite foods: \(favouriteFoodsIds)")
    }
}
