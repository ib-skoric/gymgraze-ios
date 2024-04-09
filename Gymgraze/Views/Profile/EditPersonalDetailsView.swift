//
//  EditPersonalDetailsView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 09/04/2024.
//

import SwiftUI

struct EditPersonalDetailsView: View {
    
    @State var name: String = ""
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Heading(text: "Edit personal information")
                
                if let name = userVM.user?.name {
                    InputField(data: .constant(name), title: "Email")
                }
                
                if let age = userVM.user?.age {
                    HStack(alignment: .center) {
                        InputField(data: .constant(String(age)), title: "Age (years)")
                    }
                }
                
                if let height = userVM.user?.height {
                    HStack(alignment: .center) {
                        InputField(data: .constant(String(height)), title: "Height (cm)")
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
    EditPersonalDetailsView()
}
