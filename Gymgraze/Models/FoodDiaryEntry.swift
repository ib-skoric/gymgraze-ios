//
//  FoodDiaryEntry.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

/// FoodDiaryEntry object model
struct FoodDiaryEntry: Codable {
    var id: Int
    var date: Date
    var foods: [Food]
    
    var foodsByMeal: [String: [Food]] {
        Dictionary(grouping: foods) { $0.Meal.name }
    }
}
