//
//  Food.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

/// Food object model
struct Food: Codable {
    var id: Int
    var name: String
    var nutritionalInfo: NutritionalInfo
}
