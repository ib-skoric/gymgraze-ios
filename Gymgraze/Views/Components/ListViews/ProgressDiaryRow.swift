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
                    Text("**Body Fat Percentage:** \(String(format: "%.1f", progressDiaryEntry.bodyFatPercentage))%")
                    Text("**Arm:** \(String(format: "%.1f", progressDiaryEntry.armMeasurement))cm")
                    Text("**Waist:** \(String(format: "%.1f", progressDiaryEntry.waistMeasurement))cm")
                    Text("**Chest:** \(String(format: "%.1f", progressDiaryEntry.chestMeasurement))cm")
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
