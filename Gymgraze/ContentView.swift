//
//  ContentView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @State var selectedTab = 0
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }.tag(0)
            DiaryView()
                .tabItem {
                    Label("Diary", systemImage: "book.pages.fill")
                }.tag(1)
            BarcodeScannerView()
                .tabItem {
                    Label("Quick scan", systemImage: "plus.circle")
                }.tag(2)
            TrendsView()
                .tabItem {
                    Label("Trends", systemImage: "chart.bar.xaxis.ascending")
                }.tag(3)
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }.tag(4)
        }
        .accentColor(Color(.orange))
        .onAppear(perform: {
            requestPermissions()
        })
    }
    
    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
                print("Notification permisssion granted!")
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserViewModel())
}

