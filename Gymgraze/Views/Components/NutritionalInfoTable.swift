//
//  NutritionalInfoTable.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/03/2024.
//

import SwiftUI

struct NutritionalInfoTable: View {
    
    var nutritionalInfo: NutritionalInfo
    @Binding var amount: String
    
    var body: some View {
        
        var calories = nutritionalInfo.kcal * (Int(amount) ?? 0) / 100
        var protein = nutritionalInfo.protein * (Double(amount) ?? 0) / 100
        var carbs = nutritionalInfo.carbs * (Double(amount) ?? 0) / 100
        var fat = nutritionalInfo.fat * (Double(amount) ?? 0) / 100
        var fiber = nutritionalInfo.fiber * (Double(amount) ?? 0) / 100
        var sugar = nutritionalInfo.sugar * (Double(amount) ?? 0) / 100
        var salt = nutritionalInfo.salt * (Double(amount) ?? 0) / 100

        VStack {
            HStack {
                Text("**Calories:** \(calories)")
                    .font(.subheadline)
                    .fontWeight(.light)
                Spacer()
                Text("**P:** \(protein, specifier: "%.2f")g")
                    .font(.subheadline)
                    .fontWeight(.light)
                Spacer()
                Text("**C:** \(carbs, specifier: "%.2f")g")
                    .font(.subheadline)
                    .fontWeight(.light)
                Spacer()
                Text("**F:** \(fat, specifier: "%.2f")g")
                    .font(.subheadline)
                    .fontWeight(.light)
            }
            Divider()
            HStack {
                Text("**Fiber:** \(fiber, specifier: "%.2f")g")
                    .font(.subheadline)
                    .fontWeight(.light)
                Spacer()
                Text("**Sugars:** \(sugar, specifier: "%.2f")g")
                    .font(.subheadline)
                    .fontWeight(.light)
                Spacer()
                Text("**Salt:** \(salt, specifier: "%.2f")mg")
                    .font(.subheadline)
                    .fontWeight(.light)
            }
        }
       .padding()
        .frame(height: 75)
    }
}

//#Preview {
//    NutritionalInfoTable(nutritionalInfo: NutritionalInfo())
//}
