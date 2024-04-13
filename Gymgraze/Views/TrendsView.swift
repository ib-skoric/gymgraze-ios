//
//  TrendsView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/02/2024.
//

import SwiftUI

struct TrendsView: View {
    
    @StateObject var trendsVM = TrendsViewModel()
    
    var body: some View {
        NavigationStack {
            Heading(text: "📊 Trends")
        }
        .onAppear {
            
        }
    }
}

#Preview {
    TrendsView()
}
