//
//  EditMealsview.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 09/04/2024.
//

import SwiftUI

struct EditMealsview: View {
    
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Heading(text: "Edit meals")
                
                List(userVM.user?.meals ?? []) { meal in
                    HStack {
                        TextField(meal.name, text: .constant(meal.name))
                    }
                }
                
                Spacer()
                
                Button(action: {
                    // TODO: Add action code here
                }, label: {
                    Text("Save changes")
                })
                .buttonStyle(CTAButton())
                .padding()
            }
        }
    }
}

#Preview {
    EditMealsview()
}
