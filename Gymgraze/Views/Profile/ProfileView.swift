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
    
    var body: some View {
        NavigationStack {
            Heading(text: "🧑 Profile")
            
            List {
                NavigationLink {
                    EditPersonalDetailsView()
                        .environmentObject(userVM)
                } label: {
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.gray)
                        Text("Personal information")
                    }
                }
                
                NavigationLink {
                    EditGoalsView()
                        .environmentObject(userVM)
                } label: {
                    HStack {
                        Image(systemName: "target")
                            .foregroundColor(.gray)
                        Text("Goals")
                    }
                }
                
                NavigationLink {
                    EditMealsview()
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
