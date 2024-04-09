//
//  FoodItemRow.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 23/03/2024.
//

import SwiftUI

struct FoodItemRow: View {
    
    var food: FoodItem.Product
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text((String(food.productName ?? "No name found")))
                    .font(.headline)
                Text("C: \(String(format: "%.1f", food.nutriments.carbs100g ?? 0.0)) P: \(String(format: "%.1f", food.nutriments.protein100g ?? 0.0)) F: \(String(format: "%.1f", food.nutriments.fat100g ?? 0.0))")
                    .font( .subheadline)
                    .fontWeight(.light)
                    .foregroundStyle(.gray)
            }
        }
        .padding()
    }
}

//#Preview {
//    FoodItemRow(food: FoodItem.Product())
//}
