//
//  FoodDiaryEntry.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

struct FoodDiaryEntry: Codable {
    var id: Int
    var date: Date
    var foods: [Food]
}
