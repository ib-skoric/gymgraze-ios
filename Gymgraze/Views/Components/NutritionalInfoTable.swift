//
//  NutritionalInfoTable.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/03/2024.
//

import SwiftUI

struct NutritionalInfoTable: View {
    // state and env variables to handle view updates
    var nutritionalInfo: NutritionalInfo
    @Binding var amount: String
    
    var body: some View {
        let calories_calc = Double(nutritionalInfo.kcal) * (Double(amount) ?? 0) / 100
        // round up calories calculated so that inputting 50 and 50.5 will yield slightly different results
        let calories = Int(ceil(calories_calc))
        let protein = nutritionalInfo.protein * (Double(amount) ?? 0) / 100
        let carbs = nutritionalInfo.carbs * (Double(amount) ?? 0) / 100
        let fat = nutritionalInfo.fat * (Double(amount) ?? 0) / 100
        let fiber = nutritionalInfo.fiber * (Double(amount) ?? 0) / 100
        let sugar = nutritionalInfo.sugar * (Double(amount) ?? 0) / 100
        let salt = nutritionalInfo.salt * (Double(amount) ?? 0) / 100

        VStack {
            HStack {
                // show all values in a table like format
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
            // insert a divider
            Divider()
            
            // show remaining stats
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
