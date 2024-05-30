//
//  FoodItemRow.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 23/03/2024.
//

import SwiftUI

struct FoodItemRow: View {
    
    // variables
    var food: FoodItem.Product
    @ObservedObject var viewModel: FavouriteFoodsViewModel
    
    var body: some View {
        HStack {
            // show product name if not, show no name found
            VStack(alignment: .leading) {
                Text((String(food.productName ?? "No name found")))
                    .font(.headline)
                Text("C: \(String(format: "%.1f", food.nutriments.carbs100g ?? 0.0)) P: \(String(format: "%.1f", food.nutriments.protein100g ?? 0.0)) F: \(String(format: "%.1f", food.nutriments.fat100g ?? 0.0))")
                    .font( .subheadline)
                    .fontWeight(.light)
                    .foregroundStyle(.gray)
            }
            Spacer()
            
            // add icon if the food is a favourite
            if food.id != "" && viewModel.favouriteFoodsIds.contains(food.id) || viewModel.favouriteFoods.contains(where: { $0.id == food.id }) {
                Image(systemName: "star.fill")
                    .foregroundColor(.orange)
                    .onTapGesture {
                        viewModel.handleFavourite(foodId: food.id)
                    }
            } else if food.id != "" && !viewModel.favouriteFoodsIds.contains(food.id) {
                Image(systemName: "star")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        viewModel.handleFavourite(foodId: food.id)
                    }
            }
        }
        .padding()
    }
}
