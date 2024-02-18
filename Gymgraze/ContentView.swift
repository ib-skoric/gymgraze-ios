//
//  ContentView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            MainView()
                .tabItem {
                    Label("Diary", systemImage: "book.pages.fill")
                }
            MainView()
                .tabItem {
                    Label("Quick add", systemImage: "plus.circle")
                }
            MainView()
                .tabItem {
                    Label("Trends", systemImage: "chart.bar.xaxis.ascending")
                }
            MainView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

#Preview {
    ContentView()
}

