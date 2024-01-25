//
//  LoginViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import Foundation

class LoginViewModel {
    // store state in published vars
    @Published var loggedIn = false
    @Published var accessToken = ""
    
    func login(username: String, password: String) {
        // call the API to log the user in
        guard let loginEndpoint = URL(string: "https://api.gymgraze.com/login") else {
            return
        }
        
        // create request
        var request = URLRequest(url: loginEndpoint)
        
        // set the request method
        request.httpMethod = "POST"
        
        // make a JSON object with the username and password
        let json: [String: Any] = ["username": username, "password": password]
        
        // convert the JSON object to data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // add the JSON data to the request
        request.httpBody = jsonData
        
        // add the content type header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        
            guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                // get the access token from the response
                if let accessToken = responseJSON["access_token"] as? String {
                    self.accessToken = accessToken
                    self.loggedIn = true
                }
            }
        
        }
    }
}
