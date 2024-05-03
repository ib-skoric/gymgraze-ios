//
//  FoodDetailView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/03/2024.
//

import SwiftUI

struct FoodDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var isLoading: Bool = false
    @State var food: Food
    @State var foodImageURL: String = ""
    @State private var amount: String = ""
    @EnvironmentObject var diaryVM: DiaryViewModel
    @Binding var notification: InAppNotification?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                HStack {
                    AsyncImage(url: URL(string: foodImageURL)) { image in
                        image.resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 150, height: 100)
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
                        Text("Amount (g/ml):")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        TextField("100g", text: $amount)
                            .font(.subheadline)
                            .fontWeight(.light)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .frame(width: 100)
                            .textFieldStyle(.roundedBorder)
                            .onAppear {
                                self.amount = String(food.amount)
                            }
                    }
                    .padding()
                    Spacer()
                    Button(action: {
                        print("Save button tapped")
                        updateFoodAmount()
                        dismiss()
                        notification = InAppNotification(style: .success, message: "Food item updated in diary")
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
    
    func updateFoodAmount() {
        let diaryService = DiaryService()
        
        let intAmount = Int(amount) ?? 0
        
        print(food.id)
        
        diaryService.updateFoodAmount(foodId: food.id, amount: intAmount) { result in
            switch result {
            case .success(let food):
                print(food)
                diaryVM.fetchFoodDiary()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

//#Preview {
//    FoodDetailView(food: Food(), foodImageURL: "")
//}
