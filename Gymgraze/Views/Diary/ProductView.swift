//
//  ProductView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 03/03/2024.
//

import SwiftUI

struct ProductView: View {
    
    @State var barcode: String
    @State private var amount = "100"
    @State var foodItem: FoodItem = FoodItem()
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                HStack {
                    AsyncImage(url: URL(string: foodItem.product.imageURL)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 75, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    Text(foodItem.product.productName ?? "No name found")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                .padding()
                VStack {
                    NutritionalInfoTable(nutritionalInfo: NutritionalInfo(from: foodItem.product.nutriments), amount: $amount)
                    .padding()
                    Spacer()
                }
                .padding()
            }
            Spacer()
        }
        .onAppear {
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
}

#Preview {
    ProductView(barcode: "4543435454534")
}
