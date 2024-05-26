//
//  AddProgressLogView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/04/2024.
//

import SwiftUI

struct AddProgressLogView: View {
    
    // state and env variables to handle view updates
    @Environment(\.dismiss) var dismiss
    @State var date: Date = Date()
    @EnvironmentObject var diaryVM: DiaryViewModel
    @State var weight: String = ""
    @State var bodyFatPercentage: String = ""
    @State var armMeasurement: String = ""
    @State var waistMeasurement: String = ""
    @State var chestMeasurement: String = ""
    @Binding var notification: InAppNotification?
    
    var body: some View {
        
        NavigationView {
            VStack {
                Heading(text: "Add progress log")
                
                // input fields for progress log
                InputField(data: $weight, title: "Weight (kg)")
                    .accessibilityLabel("Weight input field")
                
                InputField(data: $bodyFatPercentage, title: "Body fat percentage (%)")
                    .accessibilityLabel("Body fat percentage input field")

                InputField(data: $armMeasurement, title: "Arm measurement (cm)")
                    .accessibilityLabel("Arm measurement input field")

                InputField(data: $waistMeasurement, title: "Waist measurement (cm)")
                    .accessibilityLabel("Waist measurement input field")

                InputField(data: $chestMeasurement, title: "Chest measurement (cm)")
                    .accessibilityLabel("Chest measuremen input field")

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
                .accessibilityLabel("Add progress log button")
            }
        }
    }
    
    /// function to handle adding progress log
    func handleAddProgressLog() {
        
        // format date to string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dateString = dateFormatter.string(from: date)
        
        // add data to the struct for API to handle
        var dataToAPI = ProgressDiaryEntryToAPI(date: dateString, weight: Double(weight) ?? 0.0, body_fat_percentage: Double(bodyFatPercentage), arm_measurement: Double(armMeasurement), waist_measurement: Double(waistMeasurement), chest_measurement: Double(chestMeasurement))
        
        // call the method to send data over
        diaryVM.addToProgressDiary(progressDiaryEntry: dataToAPI) { result in
            switch result {
            case .success(_):
                // show notification
                notification = InAppNotification(style: .success, message: "Progress log added successfully")
            case .failure(let error):
                notification = InAppNotification(style: .networkError, message: "Something went wrong, try again later")
            }
        }
        dismiss()
        
    }
}
