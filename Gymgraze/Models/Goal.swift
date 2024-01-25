//
//  Goal.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

struct Goal: Codable {
    var kcal: Int
    var steps: Int
    var excercise: Int
    var updatedAt: Date
}
