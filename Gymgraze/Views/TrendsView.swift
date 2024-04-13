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
        NavigationStack {
            Heading(text: "📊 Trends")
            
            VStack {
                
            }
            Spacer()
        }
        .onAppear {
            trendsVM.fetchTrends()
        }
    }
}

#Preview {
    TrendsView()
}
