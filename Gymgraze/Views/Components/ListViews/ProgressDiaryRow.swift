//
//  ProgressDiaryRow.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/04/2024.
//

import SwiftUI


struct ProgressDiaryRow: View {
    @State var progressDiaryEntry: ProgressDiaryEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Progress log")
                    .font(.headline)
                VStack(alignment: .leading) {
                    Text("**Weight:** \(String(format: "%.1f", progressDiaryEntry.weight))kg")
                    if progressDiaryEntry.bodyFatPercentage != nil {
                        Text("**Body Fat Percentage:** \(String(format: "%.1f", progressDiaryEntry.bodyFatPercentage ?? "No data"))%")
                    }
                    if progressDiaryEntry.armMeasurement != nil {
                        Text("**Arm:** \(String(format: "%.1f", progressDiaryEntry.armMeasurement ?? "No data"))cm")
                    }
                    if progressDiaryEntry.waistMeasurement != nil {
                        Text("**Waist:** \(String(format: "%.1f", progressDiaryEntry.waistMeasurement ?? "No data"))cm")
                    }
                    if progressDiaryEntry.chestMeasurement != nil {
                        Text("**Chest:** \(String(format: "%.1f", progressDiaryEntry.chestMeasurement ?? "No data"))cm")
                    }
                }
                    .font( .subheadline)
                    .fontWeight(.light)
                    .foregroundStyle(.gray)
            }
        }
        .padding()
    }
}

//#Preview {
//    ProgressDiaryRow()
//}
