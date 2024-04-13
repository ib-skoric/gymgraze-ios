//
//  Trends.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/04/2024.
//

import Foundation

struct Trends {
    var weights: [Double]
    var bodyFatPercentages: [Double]
    var armMeasurements: [Double]
    var waistMeasurements: [Double]
    var chestMeasurements: [Double]
    
    enum CodingKeys: String, CodingKey {
        case weights
        case bodyFatPercentages = "body_fat_percentages"
        case armMeasurements = "arm_measurements"
        case waistMeasurements = "waist_measurements"
        case chestMeasurements = "chest_measurements"
    }
}
