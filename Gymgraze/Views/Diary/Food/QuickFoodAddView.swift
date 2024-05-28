//
//  QuickFoodAddView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 27/05/2024.
//

import SwiftUI

struct QuickFoodAddView: View {
    
    // state and env variables to handle view updates
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userVM: UserViewModel
    @State private var meal: Meal = Meal()
    @State private var calories: String = ""
    @State private var protein: String = ""
    @State private var carbs: String = ""
    @State private var fats: String = ""
    @State var selectedDate: Date
    @Binding var notification: InAppNotification?
    
    var body: some View {
        NavigationStack {
            VStack {
                Heading(text: "Quick food add")
                
                HStack {
                    Text("Meal:")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Spacer()
                    Picker("Meal", selection: $meal) {
                        ForEach(userVM.user?.meals ?? [], id: \.self) { meal in
                            Text(meal.name)
                                .tag(meal.id)
                        }
                    }
                    .accessibilityLabel("Meal picker")
                }
                .padding()
                
                VStack {
                    HStack {
                        Text("Calories (kcal):")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        TextField("100", text: $calories)
                            .font(.subheadline)
                            .fontWeight(.light)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
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
                            .textFieldStyle(.roundedBorder)
                            .accessibilityLabel("Fats input")
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        addFoodItemToDiary()
                        print("Save button tapped")
                        dismiss()
                    }, label: {
                        Text("Add to diary")
                    })
                    .buttonStyle(CTAButton())
                    .padding()
                    .accessibilityLabel("Add to diary button")
                }
            }
            .padding()
        }
    }
    
    /// Adds food item to user's diary
    func addFoodItemToDiary() {
        // formate date
        let diaryService = DiaryService()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormatter.string(from: selectedDate)
        
        let nutriments = FoodItem.Nutriments(kcal100g: Int(calories) ?? 0, carbs100g: Double(carbs) ?? 0, protein100g: Double(protein) ?? 0.0, fat100g: Double(fats) ?? 0.0, salt100g: 0, sugar100g: 0, fiber100g: 0)
        
        let product = FoodItem.Product(productName: "Quick add", nutriments: nutriments)
        
        let foodItem = FoodItem(product: product)
        
        // add food call to API
        diaryService.addFoodToDiary(food: foodItem, amount: 100, date: dateString, mealId: meal.id, nutritionalInfo: foodItem.product.nutriments) { result in
            switch result {
            case .success(let response):
                notification = InAppNotification(style: .success, message: "Food item added to your diary")
                print(response)
            case .failure(let error):
                notification = InAppNotification(style: .networkError, message: "Something went wrong, try again later")
                print(error)
            }
        }
    }
}

//
//#Preview {
//    QuickFoodAddView()
//}
