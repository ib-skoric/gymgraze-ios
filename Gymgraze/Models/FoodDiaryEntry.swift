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
    var date: String
    var foods: [Food]
    
    init() {
        self.id = 0
        self.date = ""
        self.foods = []
    }
    
    var foodsByMeal: [String: [Food]] {
        Dictionary(grouping: foods) { $0.meal.name }
    }
}
