//
//  Food.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

struct Food: Codable {
    var id: Int
    var name: String
    var nutritionalInfo: NutritionalInfo
}
