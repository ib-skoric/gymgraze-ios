//
//  GenieAIViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 20/04/2024.
//

import Foundation
import SwiftUI

class GenieAIViewModel: ObservableObject {
    /// Published properties used by different views to update UI
    @Published var totalDayKcal: Double = 0
    @Published var isLoading: Bool = false
    @Published var latestRecipe: String = ""
    @Published var fetchComplete: Bool = false
    
    /// method for getting the recipe from OpenAI using the provided method and macro values
    func getRecipe(method: String, kcal: String, protein: String, carbs: String, fat: String) {
        withAnimation {
            self.isLoading = true
        }
        
        // convert the macro values to Double
        let kcalDouble = Double(kcal) ?? 0
        let proteinDouble = Double(protein) ?? 0
        let carbsDouble = Double(carbs) ?? 0
        let fatDouble = Double(fat) ?? 0
        
        // call the API service to get the recipe
        OpenAIService().getOpenAIResponse(method: method, kcal: kcalDouble, protein: proteinDouble, carbs: carbsDouble, fat: fatDouble) { result in
            switch result {
            case .success(let recipe):
                self.latestRecipe = recipe
                withAnimation {
                    self.isLoading = false
                    self.fetchComplete = true
                }
            case .failure(let error):
                print(error.localizedDescription)
                withAnimation {
                    self.isLoading = false
                }
            }
        }
    }
}
