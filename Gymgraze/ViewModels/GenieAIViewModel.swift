//
//  GenieAIViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 20/04/2024.
//

import Foundation

class GenieAIViewModel: ObservableObject {
    @Published var totalDayKcal: Double = 0
    @Published var isLoading: Bool = false
    @Published var latestRecipe: String = ""
    @Published var fetchComplete: Bool = false
    
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
    
    func getRecipe(method: String, kcal: String, protein: String, carbs: String, fat: String) {
        self.isLoading = true
        
        let kcalDouble = Double(kcal) ?? 0
        let proteinDouble = Double(protein) ?? 0
        let carbsDouble = Double(carbs) ?? 0
        let fatDouble = Double(fat) ?? 0
        
        OpenAIService().getOpenAIResponse(method: method, kcal: kcalDouble, protein: proteinDouble, carbs: carbsDouble, fat: fatDouble) { result in
            switch result {
            case .success(let recipe):
                self.latestRecipe = recipe
                self.isLoading = false
                self.fetchComplete = true
            case .failure(let error):
                print(error.localizedDescription)
                self.isLoading = false
            }
        }
    }
}
