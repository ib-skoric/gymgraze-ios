//
//  AddProgressLogView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/04/2024.
//

import SwiftUI

struct AddProgressLogView: View {
    @State var date: Date = Date()
    
    var body: some View {
        
        @State var weight: String = ""
        @State var bodyFatPercentage: String = ""
        @State var armMeasurement: String = ""
        @State var waistMeasurement: String = ""
        @State var chestMeasurement: String = ""
        
        NavigationView {
            VStack {
                Heading(text: "Add progress log")
                
                InputField(data: $weight, title: "Weight (kg)")
                
                InputField(data: $bodyFatPercentage, title: "Body fat percentage (%)")
                InputField(data: $armMeasurement, title: "Arm measurement (cm)")
                InputField(data: $waistMeasurement, title: "Waist measurement (cm)")
                InputField(data: $chestMeasurement, title: "Chest measurement (cm)")

                Spacer()
                Button {
                    handleAddProgressLog()
                } label: {
                    Text("Add progress log")
                }
                .buttonStyle(CTAButton())
                .padding()
            }
        }
    }
    
    func handleAddProgressLog() {
        
    }
}

#Preview {
    AddProgressLogView()
}
