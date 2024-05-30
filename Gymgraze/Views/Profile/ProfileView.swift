//
//  ProfileView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/02/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @State private var userLoggedOut: Bool = false
    @State private var notification: InAppNotification? = nil

    var body: some View {
        NavigationStack {
            Heading(text: "🧑 Profile")
            
            List {
                NavigationLink {
                    EditPersonalDetailsView(notification: $notification)
                        .environmentObject(userVM)
                } label: {
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.gray)
                        Text("Personal information")
                    }
                }
                .accessibilityLabel("Button to navigate to personal details settings")
                
                NavigationLink {
                    EditGoalsView(notification: $notification)
                        .environmentObject(userVM)
                } label: {
                    HStack {
                        Image(systemName: "target")
                            .foregroundColor(.gray)
                        Text("Goals")
                    }
                }
                .accessibilityLabel("Button to navigate to goal settings")
                
                NavigationLink {
                    EditMealsview(notification: $notification)
                        .environmentObject(userVM)
                } label: {
                    HStack {
                        Image(systemName: "fork.knife")
                            .foregroundColor(.gray)
                        Text("Meals")
                    }
                }
                .accessibilityLabel("Button to navigate to meals settings")
                
                Button(action: {
                    logout()
                }, label: {
                        Text("Log out")
                    })
                .navigationDestination(isPresented: $userLoggedOut) {
                    LoginView().navigationBarBackButtonHidden(true)
                }
                .accessibilityLabel("Button to navigate to log out of the app")
            }
        }
        .inAppNotificationView(notification: $notification)
    }
    
    func logout() {
        DispatchQueue.main.async {
            userVM.logout()
        }
    }
}
