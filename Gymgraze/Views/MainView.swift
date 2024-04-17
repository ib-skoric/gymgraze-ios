//
//  MainView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/02/2024.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @ObservedObject var mainVM = MainViewModel()
    
    
    var randomCards: [ArticleCard] = []
    
    var body: some View {
        NavigationStack {
            Heading(text: "👋 Welcome, \(userVM.user?.name ?? "there")")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    StatCard(type: "calories", goal: userVM.user?.goal?.kcal, currentValue: mainVM.totalKcal)
                    StatCard(type: "steps", goal: userVM.user?.goal?.steps, currentValue: mainVM.steps)
                    StatCard(type: "workouts", goal: userVM.user?.goal?.exercise, currentValue: mainVM.exerciseMinutes)
                }
                .frame(height: 200)
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(mainVM.randomCards) { card in
                    NavigationLink(destination: CardDetailView(card: card)) {
                        ArticleCardView(card: card)
                            .frame(height: 350)
                            .padding(.bottom)
                    }
                }
            }
            .padding([.top, .leading, .trailing])
            
            Spacer()
        }.onAppear {
            mainVM.fetchData()
            mainVM.fetchFoodSummary()
        }
    }
}

#Preview {
    MainView().environmentObject(UserViewModel())
}
