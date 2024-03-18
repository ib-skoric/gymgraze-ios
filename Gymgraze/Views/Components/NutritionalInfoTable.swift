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
        HStack {
            Text("**Calories:** \(nutritionalInfo.kcal)")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundStyle(.gray)
            Divider()
            Text("**P:** \(nutritionalInfo.protein, specifier: "%.2f")g")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundStyle(.gray)
            Divider()
                Text("**C:** \(nutritionalInfo.carbs, specifier: "%.2f")g")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundStyle(.gray)
            Divider()
                Text("**F:** \(nutritionalInfo.fat, specifier: "%.2f")g")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundStyle(.gray)
        }
        .padding()
        .frame(height: 100)
    }
}

#Preview {
    NutritionalInfoTable(nutritionalInfo: NutritionalInfo())
}
