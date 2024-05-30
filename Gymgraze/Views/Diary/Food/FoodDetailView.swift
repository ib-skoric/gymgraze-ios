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
    @State private var calories: String = ""
    @State private var protein: String = ""
    @State private var carbs: String = ""
    @State private var fats: String = ""
    @EnvironmentObject var diaryVM: DiaryViewModel
    @Binding var notification: InAppNotification?
    
    var body: some View {
        VStack {
            // if view is loading show progress view
            if isLoading {
                ProgressView()
            } else {
                // else show actual details of the food
                if food.name == "Quick add" {
                    quickFoodViewHeading
                        .padding()
                } else {
                    normalViewHeading
                        .padding()
                }
                VStack {
                    // table to show current nutritional values
                    if food.name == "Quick add" {
                        NutritionalInfoTable(nutritionalInfo: food.nutritionalInfo, amount: .constant("100"))
                        
                    } else {
                        NutritionalInfoTable(nutritionalInfo: food.nutritionalInfo, amount: $amount)
                    }
                    if food.name == "Quick add" {
                        editAreaQuickAdd
                            .padding()
                    } else {
                        foodEditArea
                            .padding()
                    }
                    
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
    
    var normalViewHeading: some View {
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
    
    var quickFoodViewHeading: some View {
        HStack {
            Image(systemName: "bolt.square.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .accessibilityLabel("Bolt image")
            
            Text(food.name)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            Spacer()
        }
    }
    
    var editAreaQuickAdd: some View {
        VStack {
            HStack {
                // inputs and labels to values
                Text("Calories (kcal):")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Spacer()
                
                TextField("100", text: $calories)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
                    .onAppear {
                        self.calories = String(food.nutritionalInfo.kcal)
                    }
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel("Calories input")
            }
            .padding()
            
            HStack {
                Text("Protein (g):")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Spacer()
                
                TextField("10", text: $protein)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
                    .onAppear {
                        self.protein = String(food.totalNutrition.protein)
                    }
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel("Protein input")
            }
            .padding()
            
            HStack {
                Text("Carbs (g):")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Spacer()
                
                TextField("20", text: $carbs)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
                    .onAppear {
                        self.carbs = String(food.totalNutrition.carbs)
                    }
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel("Carbs input")
            }
            .padding()
            
            HStack {
                Text("Fats (g):")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Spacer()
                
                TextField("5", text: $fats)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
                    .keyboardType(.decimalPad)
                    .onAppear {
                        self.fats = String(food.totalNutrition.fat)
                    }
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel("Fats input")
            }
            .padding()
            
            Spacer()
        }
    }
    
    var foodEditArea: some View {
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
        .padding()
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
        
        if food.name != "Quick add" {
            let intAmount = Int(amount) ?? 0
            
            diaryService.updateFoodAmount(foodId: food.id, amount: intAmount) { result in
                switch result {
                case .success(let food):
                    print(food)
                    diaryVM.fetchFoodDiary()
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            
            let kcalInt = Int(calories) ?? 0
            
            diaryService.updateQuickFood(foodId: food.id, kcal: kcalInt, protein: Double(protein) ?? 0, carbs: Double(carbs) ?? 0, fats: Double(fats) ?? 0) { result in
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
}
