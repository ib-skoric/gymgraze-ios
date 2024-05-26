//
//  FoodDetailView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/03/2024.
//

import SwiftUI

struct FoodDetailView: View {
    
    // state and env variables to handle view updates
    @Environment(\.dismiss) var dismiss
    @State private var isLoading: Bool = false
    @State var food: Food
    @State var foodImageURL: String = ""
    @State private var amount: String = ""
    @EnvironmentObject var diaryVM: DiaryViewModel
    @Binding var notification: InAppNotification?
    
    var body: some View {
        VStack {
            // if view is loading show progress view
            if isLoading {
                ProgressView()
            } else {
                // else show actual details of the food
                viewHeading
                    .padding()
                VStack {
                    // table to show current nutritional values
                    NutritionalInfoTable(nutritionalInfo: food.nutritionalInfo, amount: $amount)
                    editArea
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
                    .accessibilityLabel("Save edits to food button")
                    .buttonStyle(CTAButton())
                    .padding()
                }
                .padding()
            }
            Spacer()
        }
        // on appear fertch food item and image
        .onAppear() {
            fetchFoodItem(foodId: food.id)
            fetchImage()
        }
    }
    
    var viewHeading: some View {
        HStack {
            AsyncImage(url: URL(string: foodImageURL)) { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .accessibilityLabel("\(food.name) image")
            
            Text(food.name)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            Spacer()
        }
    }
    
    var editArea: some View {
        HStack {
            // inputs and labels to change the amount
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
                .accessibilityLabel("Amount input field")
        }
    }
    
    /// method for fetchign the food item using diary service
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
    
    /// method for fetchign the food item using open food facts service
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
    
    /// function that handle supdating the food amount via the API
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
