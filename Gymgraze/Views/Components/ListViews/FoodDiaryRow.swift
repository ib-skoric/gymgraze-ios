//
//  DiaryRow.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 20/02/2024.
//

import SwiftUI

struct FoodDiaryRow: View {
    
    var food: Food
    var nutritionalInfo: NutritionalInfo
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(food.name)")
                    .font(.headline)
                Text(String(food.amount) + "g")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundStyle(.gray)
                Text("C: \(String(format: "%.1f", food.totalNutrition.carbs)) P: \(String(format: "%.1f", food.totalNutrition.protein)) F: \(String(format: "%.1f", food.totalNutrition.fat))")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundStyle(.gray)
            }
            Spacer()
            
            Text("\(food.totalNutrition.kcal)kcal")
                .font(.headline)
                .fontWeight(.light)
                .foregroundStyle(.gray)
        }
        .padding()
    }
}
//
//#Preview {
//    FoodDiaryRow(foodName: "Apple", foodWeightInG: 150.0, nutritionalInfo: NutritionalInfo())
//}
