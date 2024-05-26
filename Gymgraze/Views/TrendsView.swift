//
//  TrendsView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/02/2024.
//

import SwiftUI
import Charts

struct TrendsView: View {
    
    // state object and state for pop over show
    @StateObject var trendsVM = TrendsViewModel()
    @State private var showPopover = false
    
    var body: some View {
        // some colour defaults
        let prevColor = Color(.purple)
        let curColor = Color(.orange)
        let curGradient = LinearGradient(
            gradient: Gradient (
                colors: [
                    prevColor.opacity(0.5),
                    curColor.opacity(0.2),
                    curColor.opacity(0.05),
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
        
        NavigationStack {
            HStack {
                Heading(text: "📊 Trends")
                Spacer()
                Button("Filter") {
                    showPopover = true
                }
                .accessibilityLabel("Filter button")
                .padding(.trailing)
                .popover(isPresented: $showPopover) {
                    Heading(text: "Pick trends to show")
                        .padding([.leading, .top])
                    List(Array(trendsVM.trendsGraphsVisible.keys), id: \.self) { key in
                        Button {
                            trendsVM.trendsGraphsVisible[key]!.toggle()
                        } label: {
                            Label(key.capitalized, systemImage: trendsVM.trendsGraphsVisible[key]! ? "checkmark" : "")
                                .foregroundColor(.orange)
                        }
                        .accessibilityLabel("Button to show/hide " + key.lowercased() + " trends")
                    }
                    Spacer()
                }
            }
            ScrollView {
                // check if weight graph is visible and if it has enough data
                if trendsVM.trendsGraphsVisible["Weight"] == true {
                    GroupBox("Body weight trends") {
                        // check that no value is set to 0
                        if !trendsVM.trends.weights.contains { $0.weight == 0 } {
                            // Sort the weights array by date
                            let sortedWeights = trendsVM.trends.weights.sorted { $0.date < $1.date }
                            Chart(sortedWeights, id: \.id) { dataPoint in
                                LineMark(x: .value("Date", dataPoint.date), y: .value("Weight", dataPoint.weight))
                                    .interpolationMethod(.catmullRom)
                                
                                PointMark(x: .value("", dataPoint.date), y: .value("", dataPoint.weight))
                                
                                AreaMark(x: .value("", dataPoint.date), y: .value("", dataPoint.weight))
                                    .foregroundStyle(curGradient)
                                    .interpolationMethod(.catmullRom)
                            }
                        } else {
                            Text("Not enough data available")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .padding(.bottom)
                        }
                    }
                    .frame(height: 300)
                    .padding()
                }
                
                // check if Body fat percentage graph is visible and if it has enough data
                if trendsVM.trendsGraphsVisible["Body fat percentage"] == true {
                    GroupBox("Body fat percentage trends") {
                        if !trendsVM.trends.bodyFatPercentages.contains(where: { $0.bodyFatPercentage == 0 }) {
                            // Sort the body fat percentages array by date
                            let sortedBfPercentages = trendsVM.trends.bodyFatPercentages.sorted { $0.date < $1.date }
                            Chart(sortedBfPercentages, id: \.id) { dataPoint in
                                LineMark(x: .value("Date", dataPoint.date), y: .value("Body fat percentage", dataPoint.bodyFatPercentage ?? 0))
                                    .interpolationMethod(.catmullRom)
                                
                                PointMark(x: .value("", dataPoint.date), y: .value("", dataPoint.bodyFatPercentage ?? 0))
                                
                                AreaMark(x: .value("", dataPoint.date), y: .value("", dataPoint.bodyFatPercentage ?? 0))
                                    .foregroundStyle(curGradient)
                                    .interpolationMethod(.catmullRom)
                            }
                        }
                        else {
                            Text("Not enough data available")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .padding(.bottom)
                        }
                    }
                    .frame(height: 300)
                    .padding()
                }
                
                // check if Arm measurement graph is visible and if it has enough data
                if trendsVM.trendsGraphsVisible["Arm measurement"] == true {
                    GroupBox("Arm measurement trends") {
                        if !trendsVM.trends.armMeasurements.contains(where: { $0.armMeasurement == 0 }) {
                            // Sort the arm measurements array by date
                            let sortedArmMeasurements = trendsVM.trends.armMeasurements.sorted { $0.date < $1.date }
                            Chart(sortedArmMeasurements, id: \.id) { dataPoint in
                                LineMark(x: .value("Date", dataPoint.date), y: .value("Arm measurements", dataPoint.armMeasurement ?? 0))
                                    .interpolationMethod(.catmullRom)
                                
                                PointMark(x: .value("", dataPoint.date), y: .value("", dataPoint.armMeasurement ?? 0))
                                
                                AreaMark(x: .value("", dataPoint.date), y: .value("", dataPoint.armMeasurement ?? 0))
                                    .foregroundStyle(curGradient)
                                    .interpolationMethod(.catmullRom)
                            }
                        } else {
                            Text("Not enough data available")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .padding(.bottom)
                        }
                    }
                    .frame(height: 300)
                    .padding()
                }
                
                // check if Waist measurement graph is visible and if it has enough data
                if trendsVM.trendsGraphsVisible["Waist measurement"] == true {
                    GroupBox("Waist measurement trends") {
                        if !trendsVM.trends.waistMeasurements.contains(where: { $0.waistMeasurement == 0 }) {
                            // Sort the waist measurements array by date
                            let sortedWaistMeasurements = trendsVM.trends.waistMeasurements.sorted { $0.date < $1.date }
                            Chart(sortedWaistMeasurements, id: \.id) { dataPoint in
                                LineMark(x: .value("Date", dataPoint.date), y: .value("Waist measurements", dataPoint.waistMeasurement ?? 0))
                                    .interpolationMethod(.catmullRom)
                                
                                PointMark(x: .value("", dataPoint.date), y: .value("", dataPoint.waistMeasurement ?? 0))
                                
                                AreaMark(x: .value("", dataPoint.date), y: .value("", dataPoint.waistMeasurement ?? 0))
                                    .foregroundStyle(curGradient)
                                    .interpolationMethod(.catmullRom)
                            }
                        } else {
                            Text("Not enough data available")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .padding(.bottom)
                        }
                    }
                    .frame(height: 300)
                    .padding()
                }
                
                // check if Chest measurement graph is visible and if it has enough data
                if trendsVM.trendsGraphsVisible["Chest measurement"] == true {
                    GroupBox("Chest measurement trends") {
                        if !trendsVM.trends.chestMeasurements.contains(where: { $0.chestMeasurement == 0 }) {
                            // Sort the chest measurements array by date
                            let sortedChestMeasurements = trendsVM.trends.chestMeasurements.sorted { $0.date < $1.date }
                            Chart(sortedChestMeasurements, id: \.id) { dataPoint in
                                LineMark(x: .value("Date", dataPoint.date), y: .value("Chest measurements", dataPoint.chestMeasurement ?? 0))
                                    .interpolationMethod(.catmullRom)
                                
                                PointMark(x: .value("", dataPoint.date), y: .value("", dataPoint.chestMeasurement ?? 0))
                                
                                AreaMark(x: .value("", dataPoint.date), y: .value("", dataPoint.chestMeasurement ?? 0))
                                    .foregroundStyle(curGradient)
                                    .interpolationMethod(.catmullRom)
                            }
                        } else {
                            Text("Not enough data available")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .padding(.bottom)
                        }
                    }
                    .frame(height: 300)
                    .padding()
                }
                
                // check if steps trend graph is visible
                if trendsVM.trendsGraphsVisible["Steps trend"] == true {
                    GroupBox("Steps trend") {
                        Chart(trendsVM.stepsPerDay, id: \.id) { dataPoint in
                            BarMark(x: .value("Date", dataPoint.date), y: .value("", dataPoint.steps))
                                .cornerRadius(10)

                            }
                    }
                    .frame(height: 300)
                    .padding()
                }
            }
        }
        // on appear, fetch the trends
        .onAppear {
            trendsVM.fetchTrends()
        }
    }
}

#Preview {
    TrendsView()
}
