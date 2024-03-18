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
                Text("C: \(String(format: "%.1f", nutritionalInfo.carbs)) F: \(String(format: "%.1f", nutritionalInfo.fat)) P: \(String(format: "%.1f", nutritionalInfo.protein))")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundStyle(.gray)
            }
            Spacer()
            
            Text("\(nutritionalInfo.kcal)kcal")
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
