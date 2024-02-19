//
//  MainView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/02/2024.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
        NavigationStack {
            HStack  {
                Text("Welcome, Ivan 👋")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "gear")
                        .font(.title)
                        .foregroundColor(.gray)
                })
            }
            .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    StatCard(type: "calories")
                    StatCard(type: "steps")
                    StatCard(type: "workouts")
                }
                .frame(height: 200)
            }
            HStack {
                Text("Why not try...")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            ScrollView(.vertical, showsIndicators: false) {
                ArticleCard(image: "test", title: "Article card1", subheading: "Article card1", description: "Article card1")
                ArticleCard(image: "test", title: "Article card2", subheading: "Article card2", description: "Article card2")
                ArticleCard(image: "test", title: "Article card2", subheading: "Article card2", description: "Article card2")
            }
            .padding()
            
            Spacer()
            }
        }
    }

#Preview {
    MainView()
}
