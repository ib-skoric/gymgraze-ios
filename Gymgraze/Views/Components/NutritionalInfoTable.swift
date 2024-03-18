//
//  NutritionalInfoTable.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/03/2024.
//

import SwiftUI

struct NutritionalInfoTable: View {
    
    var nutritionalInfo: NutritionalInfo
    
    var body: some View {
        VStack {
            HStack {
                Text("**Calories:** \(nutritionalInfo.kcal)")
                    .font(.subheadline)
                    .fontWeight(.light)
                Spacer()
                Text("**P:** \(nutritionalInfo.protein, specifier: "%.2f")g")
                    .font(.subheadline)
                    .fontWeight(.light)
                Spacer()
                Text("**C:** \(nutritionalInfo.carbs, specifier: "%.2f")g")
                    .font(.subheadline)
                    .fontWeight(.light)
                Spacer()
                Text("**F:** \(nutritionalInfo.fat, specifier: "%.2f")g")
                    .font(.subheadline)
                    .fontWeight(.light)
            }
            .padding()
            Divider()
            HStack {
                Text("**Fiber:** \(nutritionalInfo.fiber, specifier: "%.2f")g")
                    .font(.subheadline)
                    .fontWeight(.light)
                Spacer()
                Text("**Sugars:** \(nutritionalInfo.sugar, specifier: "%.2f")g")
                    .font(.subheadline)
                    .fontWeight(.light)
                Spacer()
                Text("**Salt:** \(nutritionalInfo.salt, specifier: "%.2f")mg")
                    .font(.subheadline)
                    .fontWeight(.light)
            }
            .padding()
        }
        .padding()
        .frame(height: 75)
    }
}

#Preview {
    NutritionalInfoTable(nutritionalInfo: NutritionalInfo())
}
