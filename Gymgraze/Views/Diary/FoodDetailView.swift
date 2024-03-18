//
//  FoodDetailView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/03/2024.
//

import SwiftUI

struct FoodDetailView: View {
    
    var foodBarcode: Int
    @State private var isLoading: Bool = false
    @State private var food: FoodItem = FoodItem()
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                Text(food.product.nutriments.kcal100g.description)
            }
        }
        .onAppear() {
            fetchFoodItem(barcode: foodBarcode)
        }
    }
    
    func fetchFoodItem(barcode: Int) {
        let openFoodFactsService = OpenFoodFactsService()
        openFoodFactsService.fetchFoodItem(barcode: barcode) { result in
            switch result {
            case .success(let food):
                self.food = food
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
