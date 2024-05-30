//
//  MainView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/02/2024.
//

import SwiftUI

struct MainView: View {
    
    // Env and observed objects
    @EnvironmentObject var userVM: UserViewModel
    @ObservedObject var mainVM = MainViewModel()
    
    // variable to store random cards
    var randomCards: [ArticleCard] = []
    
    // actual view
    var body: some View {
        NavigationStack {
            Heading(text: "👋 Welcome, \(userVM.user?.name ?? "there")")
            
            // scroll view for quick stat cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    StatCard(type: "calories", goal: userVM.user?.goal?.kcal, currentValue: mainVM.totalKcal)
                    StatCard(type: "steps", goal: userVM.user?.goal?.steps, currentValue: mainVM.steps)
                    StatCard(type: "workouts", goal: userVM.user?.goal?.exercise, currentValue: mainVM.exerciseMinutes)
                }
                .frame(height: 200)
            }
            
            // scroll view for article tip cards
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(mainVM.randomCards) { card in
                    NavigationLink(destination: CardDetailView(card: card)) {
                        ArticleCardView(card: card)
                            .frame(height: 350)
                    }
                }
            }
            .padding([.top, .leading, .trailing])
            
            Spacer()
        }.onAppear {
            // fetch data and food summary
            mainVM.fetchData()
            mainVM.fetchFoodSummary()
        }
    }
}

#Preview {
    MainView().environmentObject(UserViewModel())
}
