//
//  FavouriteFoodsViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 27/04/2024.
//

import Foundation

class FavouriteFoodsViewModel: ObservableObject {
    
    @Published var favouriteFoods: [String] = []
    private let userDefaults = UserDefaults.standard
    
    init() {
        favouriteFoods = userDefaults.stringArray(forKey: "favouriteFoods") ?? []
    }
    
    func handleFavourite(foodId: String) {
        if favouriteFoods.contains(foodId) {
            let index = favouriteFoods.firstIndex(of: foodId)
            favouriteFoods.remove(at: index!)
        } else {
            favouriteFoods.append(foodId)
        }
        
        userDefaults.set(favouriteFoods, forKey: "favouriteFoods")
        print("Favourite foods: \(favouriteFoods)")
    }
    
//    func fetchFavouriteFoods() {
//        self.isLoading = true
//            for foodId in favouriteFoodIds {
//                OpenFoodFactsService().fetchFoodItem(barcode: foodId) { result in
//                    switch result {
//                    case .success(let food):
//                        DispatchQueue.main.async {
//                            self.favouriteFoods.append(food.product)
//                        }
//                    case .failure(let error):
//                        print("Error fetching food item: \(error)")
//                    }
//                    self.isLoading = false
//                }
//            }
//        }
}
