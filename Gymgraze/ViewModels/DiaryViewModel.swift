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
    
    
    func fetchFoodDiary() {
        DiaryService().fetchFoodDiaryEntry(date: selectedDate) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let entry):
                    self.diaryFoods = entry.foods
                    print(entry)
                    
                case .failure(let error):
                    if case APIError.entryNotFound = error {
                        print("Ran into 404 error, returning empty array...")
                        self.diaryFoods = []
                    } else {
                        print(error)
                    }
                }
            }
        }
    }
    
    func fetchWorkoutDiary() {
        DiaryService().fetchWorkoutDiaryEntry(date: selectedDate) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let entry):
                    self.diaryWokrouts = entry.workouts
                    print(entry)
                    
                case .failure(let error):
                    if case APIError.entryNotFound = error {
                        print("Ran into 404 error, returning empty array...")
                        self.diaryWokrouts = []
                    } else {
                        print(error)
                    }
                }
            }
        }
    }
}
