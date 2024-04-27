//
//  AddFoodView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/03/2024.
//

import SwiftUI

struct AddToFoodDiaryView: View {
    
    @State var searchTerm: String = ""
    @State var isBarcodeScannerPresented: Bool = false
    @State var selectedFood: FoodItem.Product?
    @StateObject var viewModel = AddToFoodDiaryViewModel()
    @StateObject var favouriteFoodsViewModel = FavouriteFoodsViewModel()
    @Binding var date: Date
    
    var body: some View {
        NavigationStack {
            VStack {
                viewHeading
                
                searchBar
                
                Spacer()
                
                if !viewModel.isLoading && !viewModel.searchCompleted {
                    favouriteFoodsView
                } else if !viewModel.isLoading && viewModel.searchCompleted {
                    listView
                }
                
            }
            .onAppear {
                print("-------------- FAVOURITE FOOD IDS ----------------", $favouriteFoodsViewModel.favouriteFoodsIds)
                print("-------------- FAVOURITE FOODS ----------------", $favouriteFoodsViewModel.favouriteFoods)
            }
        }
    }
    
    var viewHeading: some View {
        HStack {
            Heading(text: "Add food to diary")
            
            Spacer()
            
            Button(action: {
                isBarcodeScannerPresented = true
            }, label: {
                Label("", systemImage: "barcode.viewfinder")
                    .font(.system(size: 25))
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .top, endPoint: .bottom))
            })
            .padding(.trailing)
        }
    }
    
    var searchBar: some View {
        HStack {
            TextField("Search for food", text: $searchTerm)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            Button (action: {
                viewModel.searchForFood(searchTerm: searchTerm)
            }, label: {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .padding([.trailing, .leading])
                    } else {
                        Text("Search")
                    }
                }
            })
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(10)
            .foregroundColor(.white)
        }
        .navigationDestination(isPresented: $isBarcodeScannerPresented, destination: {
            BarcodeScannerView()
        })
        .padding()
    }
    
    var listView: some View {
        List(viewModel.foodItems) { foodItem in
            FoodItemRow(food: foodItem, viewModel: favouriteFoodsViewModel)
                .onTapGesture {
                    selectedFood = foodItem
                }
        }
        .sheet(item: $selectedFood) { foodItem in
            ProductView(barcode: String(foodItem.id), selectedDate: date)
        }
    }
    
    
    var favouriteFoodsView: some View {
        VStack(alignment: .leading) {
            Text("Favourite foods")
                .font(.title2)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.leading)
                // list of favourite foods
                List(favouriteFoodsViewModel.favouriteFoods) { foodItem in
                    FoodItemRow(food: foodItem, viewModel: favouriteFoodsViewModel)
                        .onTapGesture {
                            selectedFood = foodItem
                        }
                }
                .sheet(item: $selectedFood) { foodItem in
                    ProductView(barcode: String(foodItem.id), selectedDate: date)
                }
            }
        }
    }
//
//#Preview {
//    AddToFoodDiaryView()
//}
