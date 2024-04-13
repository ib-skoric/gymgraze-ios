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
                    VStack(alignment: .leading) {
                        Text("Body weight trends")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom)
                        
                        Chart(trendsVM.trends.weights, id: \.id) { dataPoint in
                            LineMark(x: .value("Date", dataPoint.date), y: .value("Weight", dataPoint.weight))
                                .interpolationMethod(.catmullRom)
                            
                            PointMark(x: .value("", dataPoint.date), y: .value("", dataPoint.weight))
                            
                            AreaMark(x: .value("", dataPoint.date), y: .value("", dataPoint.weight))
                                .foregroundStyle(curGradient)
                                .interpolationMethod(.catmullRom)
                        }
                        .foregroundStyle(.linearGradient(colors: [.orange, .purple], startPoint: .top, endPoint: .bottom))
                        .padding()
                    }
                    .frame(height: 300)
                    
                    VStack(alignment: .leading) {
                        Text("Body weight trends")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom)
                        
                        Chart(trendsVM.trends.bodyFatPercentages, id: \.id) { dataPoint in
                            LineMark(x: .value("Date", dataPoint.date), y: .value("Body fat percentage", dataPoint.bodyFatPercentage ?? 0))
                                .interpolationMethod(.catmullRom)
                            
                            PointMark(x: .value("", dataPoint.date), y: .value("", dataPoint.bodyFatPercentage ?? 0))
                            
                            AreaMark(x: .value("", dataPoint.date), y: .value("", dataPoint.bodyFatPercentage ?? 0))
                                .foregroundStyle(curGradient)
                                .interpolationMethod(.catmullRom)
                        }
                        .foregroundStyle(.linearGradient(colors: [.orange, .purple], startPoint: .top, endPoint: .bottom))
                        .padding()
                    }
                    .frame(height: 300)
                    
                    VStack(alignment: .leading) {
                        Text("Arm measurement trends")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom)
                        
                        Chart(trendsVM.trends.armMeasurements, id: \.id) { dataPoint in
                            LineMark(x: .value("Date", dataPoint.date), y: .value("Arm measurements", dataPoint.armMeasurement ?? 0))
                                .interpolationMethod(.catmullRom)
                            
                            PointMark(x: .value("", dataPoint.date), y: .value("", dataPoint.armMeasurement ?? 0))
                            
                            AreaMark(x: .value("", dataPoint.date), y: .value("", dataPoint.armMeasurement ?? 0))
                                .foregroundStyle(curGradient)
                                .interpolationMethod(.catmullRom)
                        }
                        .foregroundStyle(.linearGradient(colors: [.orange, .purple], startPoint: .top, endPoint: .bottom))
                        .padding()
                    }
                    .frame(height: 300)
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
