//
//  FoodDetailView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/03/2024.
//

import SwiftUI

struct FoodDetailView: View {
    
    @State private var isLoading: Bool = false
    @State var food: Food
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                HStack {
//                    AsyncImage(url: URL(string: food.product.imageURL)) { image in
//                        image.resizable()
//                    } placeholder: {
//                        ProgressView()
//                    }
//                    .frame(width: 75, height: 100)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    Text(food.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                .padding()
            }
            Spacer()
        }
        .onAppear() {
            fetchFoodItem(foodId: food.id)
        }
    }
    
    func fetchFoodItem(foodId: Int) {
        let diaryService = DiaryService()
        diaryService.fetchFoodItem(foodId: foodId) { result in
            switch result {
            case .success(let food):
                self.food = food
                print(food)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

//#Preview {
//    FoodDetailView(food: Food(name: "Apple", nutritionalInfo: NutritionalInfo(kcal: 120, carbs: 20, protein: 0, fat: 0, salt: 0, sugar: 0, fiber: 0), meal: ))
//}
