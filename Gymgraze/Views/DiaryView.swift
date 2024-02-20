//
//  DiaryView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/02/2024.
//

import SwiftUI

struct DiaryView: View {
    var body: some View {
        NavigationStack {
            
            Heading(text: "📒 Diary")
            
            List {
                Section(header: Text("Breakfast")) {
                    DiaryRow(foodName: "Apple", foodWeightInG: 150.0, nutritionalInfo: "C: 20, P:0, F:0", kcal: 120)
                    DiaryRow(foodName: "Cereal", foodWeightInG: 175.0, nutritionalInfo: "C: 35, P:1, F:7", kcal: 250)
                }
                Section(header: Text("Lunch")) {
                    DiaryRow(foodName: "Bread", foodWeightInG: 50.0, nutritionalInfo: "C: 40, P:5, F:1", kcal: 170)
                    DiaryRow(foodName: "Ham", foodWeightInG: 75.0, nutritionalInfo: "C: 2, P:25, F:2", kcal: 125)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
