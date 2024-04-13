//
//  AddProgressLogView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/04/2024.
//

import SwiftUI

struct AddProgressLogView: View {
    @Environment(\.dismiss) var dismiss
    @State var date: Date = Date()
    @EnvironmentObject var diaryVM: DiaryViewModel
    @State var weight: String = ""
    @State var bodyFatPercentage: String = ""
    @State var armMeasurement: String = ""
    @State var waistMeasurement: String = ""
    @State var chestMeasurement: String = ""
    
    var body: some View {
        
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
                    if diaryVM.isLoading {
                        ProgressView()
                    } else {
                        Text("Add progress log")
                    }
                }
                .buttonStyle(CTAButton())
                .padding()
            }
        }
    }
    
    func handleAddProgressLog() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dateString = dateFormatter.string(from: date)
        
        var dataToAPI = ProgressDiaryEntryToAPI(date: dateString, weight: Double(weight) ?? 0.0, body_fat_percentage: Double(bodyFatPercentage), arm_measurement: Double(armMeasurement), waist_measurement: Double(waistMeasurement), chest_measurement: Double(chestMeasurement))
        
        diaryVM.addToProgressDiary(progressDiaryEntry: dataToAPI)
        dismiss()
        
    }
}

#Preview {
    AddProgressLogView()
}
