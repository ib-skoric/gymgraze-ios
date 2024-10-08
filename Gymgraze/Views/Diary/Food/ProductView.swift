//
//  ProductView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 03/03/2024.
//

import SwiftUI

struct ProductView: View {
    
    // state and env variables to handle view updates
    @Environment(\.dismiss) var dismiss
    @State var barcode: String
    @State private var amount = "100"
    @State var foodItem: FoodItem = FoodItem()
    @State var isLoading: Bool = false
    @State private var showDiaryView = false
    @EnvironmentObject var userVM: UserViewModel
    @State var selectedDate: Date
    @State private var meal: Meal = Meal()
    @Binding var notification: InAppNotification?
    
    var body: some View {
        VStack {
            // if view is loading show progress view
            if isLoading {
                ProgressView()
            } else {
                // else show product view
                viewHeading
                .padding()
                Text("Typical serving size: " + (foodItem.product.servingSize ?? "Unknown"))
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                editArea
                .padding()
            }
            Spacer()
        }
        .onAppear {
            meal = userVM.user?.meals?.first ?? Meal()
            fetchFoodItem()
        }
    }
    
    var viewHeading: some View {
        HStack {
            AsyncImage(url: URL(string: foodItem.product.imageURL ?? "https://placehold.co/400")) { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(foodItem.product.productName ?? "No name found")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding(.leading)
        }
    }

    var editArea: some View {
        VStack {
            NutritionalInfoTable(nutritionalInfo: NutritionalInfo(from: foodItem.product.nutriments), amount: $amount)
                .padding(.bottom)
            HStack {
                Text("Date:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Spacer()
                DatePicker(selection: $selectedDate, displayedComponents: .date) {
                    EmptyView()
                }
                .accessibilityLabel("Date picker")
            }
            .padding()
            
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
            
            HStack {
                Text("Amount (g/ml):")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Spacer()
                
                TextField("100", text: $amount)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel("Amount input")
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
    
    /// Fetches food item from OpenFoodFacts API
    func fetchFoodItem() {
        let openFoodFactsService = OpenFoodFactsService()
        openFoodFactsService.fetchFoodItem(barcode: barcode) { result in
            switch result {
            case .success(let foodItem):
                self.foodItem = foodItem
                print(foodItem)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Adds food item to user's diary
    func addFoodItemToDiary() {
        // formate date
        let diaryService = DiaryService()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormatter.string(from: selectedDate)
        
        // add food call to API
        diaryService.addFoodToDiary(food: foodItem, amount: Double(amount) ?? 0, date: dateString, mealId: meal.id, nutritionalInfo: foodItem.product.nutriments) { result in
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
