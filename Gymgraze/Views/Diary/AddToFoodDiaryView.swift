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
    
    var body: some View {
        NavigationStack {
            VStack {
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
                
                HStack {
                    TextField("Search for food", text: $searchTerm)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    Button {
                        // Add food to diary
                    } label: {
                        HStack {
                            Text("Search")
                        }
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }
                }
                .navigationDestination(isPresented: $isBarcodeScannerPresented, destination: {
                    BarcodeScannerView()
                })
                .padding()
                
                Spacer()
            }
        }
    }
}

#Preview {
    AddToFoodDiaryView()
}
