//
//  DiaryViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 10/03/2024.
//

import Foundation

class DiaryViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var diaryFoods: [Food] = FoodDiaryEntry().foods
    @Published var diaryWokrouts: [Workout] = WorkoutDiaryEntry().workouts
    @Published var isLoading = false
    
    @Published var workoutAdded: Bool = false
    
    func fetchFoodDiary() {
        self.isLoading = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dateString = dateFormatter.string(from: selectedDate)

        DiaryService().fetchFoodDiaryEntry(date: dateString) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let entry):
                    self.diaryFoods = entry.foods
                    print(entry)
                    self.isLoading = false

                case .failure(let error):
                    if case APIError.entryNotFound = error {
                        print("Ran into 404 error, returning empty array...")
                        self.diaryFoods = []
                    } else {
                        print(error)
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    func fetchWorkoutDiary() {
        self.isLoading = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dateString = dateFormatter.string(from: selectedDate)
        
        DiaryService().fetchWorkoutDiaryEntry(date: dateString) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let entry):
                    self.diaryWokrouts = entry.workouts
                    self.workoutAdded = true
                    self.isLoading = false
                case .failure(let error):
                    if case APIError.entryNotFound = error {
                        print("Ran into 404 error, returning empty array...")
                        self.diaryWokrouts = []
                    } else {
                        print(error)
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    
}
