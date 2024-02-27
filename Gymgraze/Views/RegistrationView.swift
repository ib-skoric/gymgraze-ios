//
//  RegistrationView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 08/02/2024.
//

import SwiftUI

struct RegistrationView: View {
    // ----- Variables -----
    @State var email: String = ""
    @State var password: String = ""
    @State var name: String = ""
    @State var step: Int = 0
    @State var age: String = ""
    @State var weight: String = ""
    @State var height: String = ""
    @State var isLoading: Bool = false
    @State var emailError: String = ""
    @State var passwordError: String = ""
    @State var nameError: String = ""
    @State var ageError: String = ""
    @State var weightError: String = ""
    @State var heightError: String = ""
    // view model
    @StateObject private var registrationVM = RegistrationViewModel()
    @EnvironmentObject var loginVM: LoginViewModel
    // Object to store registration steps
    struct Step {
        let question: String
        let placeholder: String
        let binding: Binding<String>
        let error: Binding<String>
    }
    // array to hold all steps
    var steps: [Step] {
        [
            Step(question: "What's a good email to contact you on?", placeholder: "Email", binding: $email, error: $emailError),
            Step(question: "Give us a password to keep your account safe and sound!", placeholder: "Password", binding: $password, error: $passwordError),
            Step(question: "What should we call you?", placeholder: "Name", binding: $name, error: $nameError),
            Step(question: "What is your age?", placeholder: "Age", binding: $age, error: $ageError),
            Step(question: "What is your current weight?", placeholder: "Weight", binding: $weight, error: $weightError),
            Step(question: "What is your current height?", placeholder: "Height", binding: $height, error: $heightError)
        ]
    }
    var body: some View {
        NavigationStack {
            // Main Vstack
            VStack {
                Text("Join us!")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.bold)
                Text("Create an account to get started")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top)
            Spacer()
            // check current step count
            if step < steps.count {
                VStack {
                    Text(steps[step].question)
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                    InputField(data: steps[step].binding, title: steps[step].placeholder)
                        .accessibilityLabel("\(steps[step].placeholder) input field")
                    if !steps[step].error.wrappedValue.isEmpty {
                        Text(steps[step].error.wrappedValue)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .transition(.push(from: .trailing))
            } else {
                // Vstack for the last step of the registration process
                VStack {
                    Text("That's all!\n\n Ready?\n Hit the button below and let's go! 🚀")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                }
                .transition(.push(from: .trailing))
            }
            Spacer()
            // conditionally display different buttons
            if step < steps.count {
                Button(action: {
                    if validateField(step: step) {
                        withAnimation {
                            step += 1
                        }
                    }
                }, label: {
                    Text("Next")
                }).buttonStyle(CTAButton())
                    .padding()
                    .accessibilityLabel("Next step button")
            } else {
                Button(action: {
                    if validateAllFields() {
                        isLoading = true
                        // convert string values to int
                        let ageInt = Int(age) ?? 0
                        let heightInt = Int(height) ?? 0
                        // convert string values to double
                        let weightDouble = Double(weight) ?? 0.0
                        let registration = Registration(email: email, password: password, name: name, age: ageInt, weight: weightDouble, height: heightInt)
                        // we call registration method which returnes a closure
                        registrationVM.register(registration: registration) { (result) in
                            DispatchQueue.main.async {
                                switch result {
                                    // we check if the closure is 'success'
                                case .success(let email):
                                    // Start authentication process after successful registration
                                    loginVM.email = email
                                    loginVM.password = password
                                    loginVM.authenticate()
                                    // else, if the registration has failed, return an error
                                case .failure(let error):
                                    print("Oops something went wrong \(error)")
                                }
                            }
                        }
                    }
                }, label: {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Sign up")
                    }
                }).buttonStyle(CTAButton())
                    .padding()
                    .accessibilityLabel("Sign up button")
            }
        }
    }
    
    func validateField(step: Int) -> Bool {
        let value = steps[step].binding.wrappedValue
        
        if value.isEmpty {
            steps[step].error.wrappedValue = "This field cannot be empty"
            return false
        } else {
            steps[step].error.wrappedValue = ""
            return true
        }
    }
    func validateAllFields() -> Bool {
        var allValid = true
        for i in 0..<steps.count {
            if !validateField(step: i) {
                allValid = false
            }
        }
        return allValid
    }
}


#Preview {
    RegistrationView()
}
