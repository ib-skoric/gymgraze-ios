//
//  OpenFoodFactsSearchResult.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 23/03/2024.
//

import Foundation

struct OpenFoodFactsSearchResult: Decodable {
    let products: [FoodItem.Product]
}
