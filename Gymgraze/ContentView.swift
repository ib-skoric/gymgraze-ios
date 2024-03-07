//
//  ContentView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            DiaryView()
                .tabItem {
                    Label("Diary", systemImage: "book.pages.fill")
                }
            BarcodeScannerView()
                .tabItem {
                    Label("Quick add", systemImage: "plus.circle")
                }
            TrendsView()
                .tabItem {
                    Label("Trends", systemImage: "chart.bar.xaxis.ascending")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

#Preview {
    ContentView().environmentObject(LoginViewModel())
}

