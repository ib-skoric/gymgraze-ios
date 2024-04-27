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
            userDefaults.set(favouriteFoods, forKey: "favouriteFoods")
            print("Favourite foods: \(favouriteFoods)")
        } else {
            favouriteFoods.append(foodId)
            userDefaults.set(favouriteFoods, forKey: "favouriteFoods")
            print("Favourite foods: \(favouriteFoods)")
        }
    }
}
