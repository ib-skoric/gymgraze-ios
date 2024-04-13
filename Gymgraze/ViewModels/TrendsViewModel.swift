//
//  TrendsViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/04/2024.
//

import Foundation

class TrendsViewModel: ObservableObject {
    @Published var trends: Trends
    @Published var trendsGraphsVisible: [String: Bool] = ["Weight": true, "Body fat percentage": false, "Arm measurement": false, "Waist measurement": false, "Chest measurement": false]
    
    init() {
        trends = Trends(weights: [], bodyFatPercentages: [], armMeasurements: [], waistMeasurements: [], chestMeasurements: [])
    }
    
    func fetchTrends() {
        UserService().fetchTrends() { result in
            switch result {
            case .success(let trends):
                self.trends = trends
            case .failure(let error):
                print(error)
            }
        }
    }
}
