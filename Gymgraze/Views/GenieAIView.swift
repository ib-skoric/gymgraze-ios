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
        
        Text("Your current remaining kcal: \(goalKcal - Int(totalKcal))")
    }
}

#Preview {
    GenieAIView()
}
