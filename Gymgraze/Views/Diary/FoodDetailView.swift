//
//  FoodDetailView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/03/2024.
//

import SwiftUI

struct FoodDetailView: View {
    
    var food: Food
    
    var body: some View {
        VStack {
            Text(food.name)
            Text(String(food.nutritionalInfo.kcal))
            
        }.onAppear() {
            fetchFoodItem(barcode: "0035826086433")
        }
    }
    
    func fetchFoodItem(barcode: String) {
        let openFoodFactsService = OpenFoodFactsService()
        openFoodFactsService.fetchFoodItem(barcode: barcode) { result in
            switch result {
            case .success(let food):
                print(food)
            case .failure(let error):
                print(error)
            }
        }
    }

}

//#Preview {
//    FoodDetailView(food: Food(name: "Apple", nutritionalInfo: NutritionalInfo(kcal: 120, carbs: 20, protein: 0, fat: 0, salt: 0, sugar: 0, fiber: 0), meal: ))
//}
