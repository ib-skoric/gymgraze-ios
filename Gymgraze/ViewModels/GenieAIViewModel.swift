//
//  GenieAIViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 20/04/2024.
//

import Foundation

class GenieAIViewModel: ObservableObject {
    @Published var totalDayKcal: Double = 0
    
    func fetchFoodSummary() {
        DiaryService().fetchFoodSummary { result in
            switch result {
            case .success(let foodSummary):
                self.totalDayKcal = foodSummary.kcal
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
