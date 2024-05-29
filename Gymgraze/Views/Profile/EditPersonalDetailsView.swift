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
    @State private var showConfirmationModal = false
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
                
                Button(action: {
                    showConfirmationModal = true
                }, label: {
                    Text("Delete my account")
                        .foregroundColor(.primary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                })
                .padding()
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
            .alert(isPresented: $showConfirmationModal) {
                Alert(title: Text("Are you sure you want to delete your account?"), message: Text("This action cannot be undone."), primaryButton: .destructive(Text("Delete"), action: {
                    deleteUserProfile(userId: userVM.user?.id ?? 0)
                }), secondaryButton: .cancel())
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
    
    func deleteUserProfile(userId: Int) {
        
        let userService = UserService()
        
        userService.deleteProfile(userId: userId) { result in
            switch result {
            case .success:
                logout()
                print("Successfully deleted account")
            case .failure:
                print("Failed to delete account")
            }
        }
    }
    
    func logout() {
        DispatchQueue.main.async {
            userVM.logout()
        }
    }
}
