//
//  AddFoodView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/03/2024.
//

import SwiftUI

struct AddToFoodDiaryView: View {
    
    // state and env variables to handle view updates
    @State var searchTerm: String = ""
    @State var isBarcodeScannerPresented: Bool = false
    @State var isQuickAddPresented: Bool = false
    @State var selectedFood: FoodItem.Product?
    @StateObject var viewModel = AddToFoodDiaryViewModel()
    @StateObject var favouriteFoodsViewModel = FavouriteFoodsViewModel()
    @Binding var date: Date
    @State private var notification: InAppNotification? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                // view heading view
                viewHeading
                
                // search bar areaa
                searchBar
                
                Spacer()
                
                if !viewModel.isLoading && !viewModel.searchCompleted {
                    // list favourite foods
                    favouriteFoodsView
                } else if !viewModel.isLoading && viewModel.searchCompleted {
                    // list search results
                    listView
                }
                
            }
        }
        .inAppNotificationView(notification: $notification)
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
            .accessibilityLabel("Barcode scanner button")
            
            Button(action: {
                isQuickAddPresented = true
            }, label: {
                Label("", systemImage: "bolt.fill")
                    .font(.system(size: 25))
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .top, endPoint: .bottom))
            })
            .padding(.trailing)
            .accessibilityLabel("Quick add food button")
        }
    }
    
    var searchBar: some View {
        HStack {
            // input field
            TextField("Search for food", text: $searchTerm)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .accessibilityLabel("Search for food input field")
            
            // button
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
            .accessibilityLabel("Search button")
        }
        .navigationDestination(isPresented: $isBarcodeScannerPresented, destination: {
            BarcodeScannerView()
        })
        .sheet(isPresented: $isQuickAddPresented) {
            QuickFoodAddView(selectedDate: date, notification: $notification)
        }
        .padding()
    }
    
    var listView: some View {
        // list of search results
        List(viewModel.foodItems) { foodItem in
            FoodItemRow(food: foodItem, viewModel: favouriteFoodsViewModel)
                .onTapGesture {
                    selectedFood = foodItem
                }
        }
        .sheet(item: $selectedFood) { foodItem in
            ProductView(barcode: String(foodItem.id), selectedDate: date, notification: $notification)
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
                    ProductView(barcode: String(foodItem.id), selectedDate: date, notification: $notification)
                }
            }
        }
    }
