//
//  ContentView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button(action: { removeToken() }) {
                Text("Logout")
            }
        }
        .padding()
    }
    
    func removeToken() {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                            kSecAttrAccount as String: "token"]
                let status = SecItemDelete(query as CFDictionary)
                if status == errSecSuccess {
                    print("Token removed successfully")
                } else {
                    print("Failed to remove token")
                }
    }
}

#Preview {
    MainView()
}
