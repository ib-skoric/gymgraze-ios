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
        Text(food.name)
        Text(String(food.nutritionalInfo.kcal))
    }
}

//#Preview {
//    FoodDetailView(food: Food(name: "Apple", nutritionalInfo: NutritionalInfo(kcal: 120, carbs: 20, protein: 0, fat: 0, salt: 0, sugar: 0, fiber: 0), meal: ))
//}
