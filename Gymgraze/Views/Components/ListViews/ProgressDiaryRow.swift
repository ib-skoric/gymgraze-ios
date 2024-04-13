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
                Text("**Weight:** \(String(format: "%.1f", progressDiaryEntry.weight))kg\n**Chest Measurement:** \(String(format: "%.1f", progressDiaryEntry.chestMeasurement))cm\n**Arm Measurement:** \(String(format: "%.1f", progressDiaryEntry.armMeasurement))cm\n**Waist Measurement:** \(String(format: "%.1f", progressDiaryEntry.waistMeasurement))cm\n**Body Fat Percentage:** \(String(format: "%.1f", progressDiaryEntry.bodyFatPercentage))%")
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
