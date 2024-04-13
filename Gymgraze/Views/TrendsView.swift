//
//  TrendsView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/02/2024.
//

import SwiftUI
import Charts

struct TrendsView: View {
    
    @StateObject var trendsVM = TrendsViewModel()
    
    var body: some View {
        
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
            Heading(text: "📊 Trends")
            ScrollView {
                GroupBox("Body weight trends") {
                    // check that no value is set to 0
                    if !trendsVM.trends.weights.contains { $0.weight == 0 } {
                        Chart(trendsVM.trends.weights, id: \.id) { dataPoint in
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
                
                GroupBox("Body fat percentage trends") {
                    if !trendsVM.trends.bodyFatPercentages.contains(where: { $0.bodyFatPercentage == 0 }) {
                        Chart(trendsVM.trends.bodyFatPercentages, id: \.id) { dataPoint in
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
                
                GroupBox("Arm measurement trends") {
                    
                    if !trendsVM.trends.armMeasurements.contains(where: { $0.armMeasurement == 0 }) {
                        Chart(trendsVM.trends.armMeasurements, id: \.id) { dataPoint in
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
                
                GroupBox("Waist measurement trends") {
                    
                    if !trendsVM.trends.waistMeasurements.contains(where: { $0.waistMeasurement == 0 }) {
                        Chart(trendsVM.trends.waistMeasurements, id: \.id) { dataPoint in
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
                
                GroupBox("Chest measurement trends") {
                    
                    if !trendsVM.trends.chestMeasurements.contains(where: { $0.chestMeasurement == 0 }) {
                        Chart(trendsVM.trends.chestMeasurements, id: \.id) { dataPoint in
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
        }
        .onAppear {
            trendsVM.fetchTrends()
        }
    }
}

#Preview {
    TrendsView()
}
