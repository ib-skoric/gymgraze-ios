//
//  ProductView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 03/03/2024.
//

import SwiftUI

struct ProductView: View {
    
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
            if isLoading {
                ProgressView()
            } else {
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
                .padding()
                Text("Typical serving size: " + (foodItem.product.servingSize ?? "Unknown"))
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
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
                    }
                    .padding()
                    
                    HStack {
                        Text("Amount (g/ml):")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        TextField("100g", text: $amount)
                            .font(.subheadline)
                            .fontWeight(.light)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
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
                }
                .padding()
            }
            Spacer()
        }
        .onAppear {
            meal = userVM.user?.meals?.first ?? Meal()
            fetchFoodItem()
        }
    }
    
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
    
    func addFoodItemToDiary() {
        let diaryService = DiaryService()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormatter.string(from: selectedDate)
        
        diaryService.addFoodToDiary(food: foodItem, amount: Double(amount) ?? 0, date: dateString, mealId: meal.id, nutritionalInfo: foodItem.product.nutriments) { result in
            switch result {
            case .success(let response):
                notification = InAppNotification(style: .success, message: "Food item added to your diary")
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}

//#Preview {
//    ProductView(barcode: "4543435454534", selectedDate: Date())
//        .environmentObject(UserViewModel())
//}
