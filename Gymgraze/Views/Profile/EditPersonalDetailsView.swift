//
//  EditPersonalDetailsView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 09/04/2024.
//

import SwiftUI

struct EditPersonalDetailsView: View {
    
    @State var name: String = ""
    @State var age: String = ""
    @State var height: String = ""
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Heading(text: "Edit personal information")
                
                InputField(data: $name, title: "Name")
                
                HStack(alignment: .center) {
                    InputField(data: $age, title: "Age (years)")
                }
                
                HStack(alignment: .center) {
                    InputField(data: $height, title: "Height (cm)")
                }
                
                Spacer()
                
                Button(action: {
                    userVM.updatePersonalDetails(name: name, age: Int(age) ?? 0, height: Int(height) ?? 0) { result in
                        switch result {
                        case .success:
                            print("Successfully updated personal details")
                        case .failure:
                            print("Failed to update personal details")
                        }
                    }
                }, label: {
                    Text("Save changes")
                })
                .buttonStyle(CTAButton())
                .padding()
            }
            .onAppear {
                self.name = userVM.user?.name ?? ""
                self.age = String(userVM.user?.age ?? 0)
                self.height = String(userVM.user?.height ?? 0)
            }
        }
    }
}

#Preview {
    EditPersonalDetailsView()
}
