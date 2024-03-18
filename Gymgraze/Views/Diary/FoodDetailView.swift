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
    @State var foodImageURL: String = ""
    @State private var amount: String = ""
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                HStack {
                    AsyncImage(url: URL(string: foodImageURL)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 75, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    Text(food.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                .padding()
                VStack {
                    NutritionalInfoTable(nutritionalInfo: food.nutritionalInfo, amount: $amount)
                    HStack {
                        Text("Amount (g):")
                            .font(.subheadline)
                            .fontWeight(.light)
                        Spacer()
                        TextField("100g", text: $amount)
                            .font(.subheadline)
                            .fontWeight(.light)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .onAppear {
                                self.amount = String(food.amount)
                            }
                    }
                    .padding()
                    Spacer()
                    Button(action: {
                        // TODO: Actually save item
                        print("Save button tapped")
                    }, label: {
                        Text("Save item")
                    })
                    .buttonStyle(CTAButton())
                    .padding()
                }
                .padding()
            }
            Spacer()
        }
        .onAppear() {
            fetchFoodItem(foodId: food.id)
            fetchImage()
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
    
    func fetchImage() {
        let openFoodFactsService = OpenFoodFactsService()
        openFoodFactsService.fetchFoodItemImage(barcode: food.barcode) { result in
            switch result {
            case .success(let imageURL):
                self.foodImageURL = imageURL
                print(imageURL)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

#Preview {
    FoodDetailView(food: Food(), foodImageURL: "")
}
