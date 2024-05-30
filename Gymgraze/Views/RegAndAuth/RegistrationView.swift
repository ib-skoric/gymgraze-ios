//
//  RegistrationView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 08/02/2024.
//

import SwiftUI

struct RegistrationView: View {
    // State variables
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
    
    @State var showEmailConfirmationView: Bool = false
    
    // view model
    @EnvironmentObject var userVM: UserViewModel
    
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
            Step(question: "What is your current weight?", placeholder: "Weight (kg)", binding: $weight, error: $weightError),
            Step(question: "What is your current height?", placeholder: "Height (cm)", binding: $height, error: $heightError)
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
                            .padding()
                    }
                }
                .transition(.push(from: .trailing))
            } else {
                // Vstack for the last step of the registration process
                VStack {
                    Text("That's all!\n\n Ready?\n Hit the button below and let's go! 🚀")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                    Text("By signing up, you agree to your data being processed in the European Union")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .padding()
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
                        registerUser()
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
                    .background {
                        NavigationLink(destination: ConfirmationCodeInputView(confirmationType: "email").navigationBarBackButtonHidden(true), isActive: $showEmailConfirmationView) {}
                    }
            }
        }
    }
    
    /// function that validates field based on it's step ID
    func validateField(step: Int) -> Bool {
        let field = steps[step].placeholder
        let value = steps[step].binding.wrappedValue
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        var isValid: Bool = false
        
        // validates if the field is not empty
        if value.isEmpty {
            steps[step].error.wrappedValue = "This field cannot be empty"
        } else {
            steps[step].error.wrappedValue = ""
            isValid = true
        }
        
        // validates email field
        if field == "Email" {
            let semaphore = DispatchSemaphore(value: 0)
            validateEmail(email: value) { result in
                if result {
                    // Move to the next step
                    isValid = true
                } else {
                    // Show an error message
                    isValid = false
                }
                semaphore.signal()
            }
            semaphore.wait()
        }
        
        // validates password field
        if field == "Password" {
            if passwordTest.evaluate(with: value) {
                steps[step].error.wrappedValue = ""
                isValid = true
            } else {
                steps[step].error.wrappedValue = "Password must be at least 8 characters long and have uppercase & lowecase characters as well as a number"
                isValid = false
            }
        }
        
        if field == "Age" || field == "Height" || field == "Weight" {
            let intValue = Int(value) ?? nil
            
            if intValue != nil && intValue! <= 18 {
                steps[step].error.wrappedValue = "Value must be positive and you must be over 18 years of age"
                isValid = false
            }
        }
        
        return isValid
        
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
    
    func registerUser() {
        isLoading = true
        // convert string values to int
        let ageInt = Int(age) ?? 0
        let heightInt = Int(height) ?? 0
        // convert string values to double
        let weightDouble = Double(weight) ?? 0.0
        let registration = Registration(email: email, password: password, name: name, age: ageInt, weight: weightDouble, height: heightInt)
        // we call registration method which returnes a closure
        RegistrationService().register(registration: registration) { (result) in
            DispatchQueue.main.async {
                switch result {
                    // we check if the closure is 'success'
                case .success(let user):
                    // set user to userVM
                    userVM.user = user
                    // Start authentication process after successful registration
                    userVM.logout()
                    userVM.email = email
                    userVM.password = password
                    userVM.authenticate() { (result) in
                        switch result {
                        case .success:
                            Task.init {
                                await userVM.fetchUser()
                            }
                            showEmailConfirmationView = true
                        case .failure:
                            print("Failed authing user after sign up")
                        }
                    }
                    // else, if the registration has failed, return an error
                case .failure(let error):
                    print("Oops something went wrong \(error)")
                }
            }
        }
    }
    
    func checkEmailExists(email: String, completion: @escaping (Bool) -> Void) {
        UserService().checkEmailExists(email: email) { result in
            switch result {
            case .success(let exists):
                completion(false)
            case .failure(let error):
                completion(true)
            }
        }
    }
    
    func validateEmail(email: String, completion: @escaping (Bool) -> Void) {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
            checkEmailExists(email: email) { result in
                if result {
                    steps[step].error.wrappedValue = "User with this email already exists."
                    completion(false)
                } else if emailTest.evaluate(with: email) {
                    completion(true)
                } else {
                    steps[step].error.wrappedValue = "This email address is not valid"
                    completion(false)
                }
            }
    }

}
#Preview {
    RegistrationView()
}
