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
                
                Button(action: {
                    logout()
                }, label: {
                        Text("Log out")
                    })
                .navigationDestination(isPresented: $userLoggedOut) {
                    LoginView().navigationBarBackButtonHidden(true)
                }
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

//#Preview {
//    ProfileView()
//}
