//
//  GenieAIView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 20/04/2024.
//

import SwiftUI

struct GenieAIView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @ObservedObject var genieAIVM = GenieAIViewModel()
    
    var body: some View {
        let goalKcal = userVM.user?.goal?.kcal ?? 0
        let totalKcal = genieAIVM.totalDayKcal
        
        VStack {
            if genieAIVM.isLoading {
                VStack(alignment: .center) {
                    Text("🧞‍♂️")
                        .font(.system(size: 60))
                    
                    Text("Thinking...")
                    ProgressView()
                }
                .padding(.top)
            }
        }
        .onAppear {
            genieAIVM.fetchFoodSummary()
            genieAIVM.getRecipe()
        }
    }
}

#Preview {
    GenieAIView()
}
