//
//  DiaryRow.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 20/02/2024.
//

import SwiftUI

struct FoodDiaryRow: View {
    
    var foodName: String
    var foodWeightInG: Double
    // TODO: This should be changed
    var nutritionalInfo: NutritionalInfo
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(foodName)")
                    .font(.headline)
                Text(String(format: "%.1f", foodWeightInG) + "g")
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

//#Preview {
//    DiaryRow(foodName: "Apple", foodWeightInG: 150.0, nutritionalInfo: "C: 20, P:0, F:0", kcal: 120)
//}
