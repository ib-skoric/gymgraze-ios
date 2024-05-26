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
    @Binding var notification: InAppNotification?
    
    var body: some View {
        NavigationView {
            VStack {
                Heading(text: "Edit personal information")
                
                // input fields to edit personal details
                InputField(data: $name, title: "Name")
                    .accessibilityLabel("Name input field")

                
                HStack(alignment: .center) {
                    InputField(data: $age, title: "Age (years)")
                        .accessibilityLabel("Age input field")

                }
                
                HStack(alignment: .center) {
                    InputField(data: $height, title: "Height (cm)")
                        .accessibilityLabel("Height input field")
                }
                
                Spacer()
            }
            // on appear fetch detail
            .onAppear {
                self.name = userVM.user?.name ?? ""
                self.age = String(userVM.user?.age ?? 0)
                self.height = String(userVM.user?.height ?? 0)
            }
            // on disappear update the details
            .onDisappear {
                handlePersonalDetailsUpdate()
            }
        }
    }
    
    /// function to handle personal details update
    func handlePersonalDetailsUpdate() {
        userVM.updatePersonalDetails(name: name, age: Int(age) ?? 0, height: Int(height) ?? 0) { result in
            switch result {
            case .success:
                // show notificaiton
                notification = InAppNotification(style: .success, message: "Personal details updated!")
                print("Successfully updated personal details")
            case .failure:
                print("Failed to update personal details")
            }
        }
    }
}
