//
//  GenieAIView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 20/04/2024.
//

import SwiftUI

struct GenieAIView: View {
    
    // state and env variables to handle view updates
    @EnvironmentObject var userVM: UserViewModel
    @ObservedObject var genieAIVM = GenieAIViewModel()
    @State var kcal: String = ""
    @State var carbs: String = ""
    @State var protein: String = ""
    @State var fat: String = ""
    
    var body: some View {
        
        VStack {
            // check if genie is loading to show progress view
            if genieAIVM.isLoading {
                VStack(alignment: .center) {
                    Text("🧞‍♂️")
                        .font(.system(size: 80))
                    
                    Text("Cooking up a storm...")
                    ProgressView()
                }
                .padding(.top)
                // if fetch is completed, show the recipe
            } else if genieAIVM.fetchComplete == true {
                recipeView
            } else {
                startGenieView
            }
        }
    }
    
    var recipeView: some View {
        VStack {
            Heading(text: "🧞‍♂️ Genie's Recipe")
            ScrollView {
                Text(genieAIVM.latestRecipe)
                    .padding([.bottom, .leading, .trailing])
            }
            Spacer()
            Button("Another recipe", systemImage: "arrow.counterclockwise") {
                genieAIVM.getRecipe(method: "retry", kcal: kcal, protein: protein, carbs: carbs, fat: fat)
            }
            .accessibilityLabel("Get another recipe button")
            .buttonStyle(CTAButton())
            .padding()
        }
    }
    
    var startGenieView: some View {
        VStack {
            Spacer()
            
            VStack {
                Text("🧞‍♂️")
                    .font(.system(size: 80))
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .top, endPoint: .bottom))

                Text("GenieAI")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .top, endPoint: .bottom))
            }
            
            Text("Tell Genie how many calories you'd like your recipe to contain")
                .multilineTextAlignment(.center)
                .font(.headline)
                .padding()
            
            TextField(text: $kcal) {
                Text("Calories (kcal)")
            }
            .font(.subheadline)
            .fontWeight(.light)
            .multilineTextAlignment(.center)
            .frame(width: 250)
            .keyboardType(.numberPad)
            .textFieldStyle(.roundedBorder)
            .padding()
            .accessibilityLabel("Calories input field")

            
            
            Text("And pick one of the following...")
                .multilineTextAlignment(.center)
                .font(.headline)
                .padding()
            
            HStack {
                TextField(text: $carbs) {
                    Text("Carbs (g)")
                }
                .font(.subheadline)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .disabled(!protein.isEmpty || !fat.isEmpty)
                .accessibilityLabel("Carbs input field")

                
                TextField(text: $protein) {
                    Text("Protein (g)")
                }
                .font(.subheadline)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .disabled(!carbs.isEmpty || !fat.isEmpty)
                .accessibilityLabel("Protein input field")

                
                TextField(text: $fat) {
                    Text("Fat (g)")
                }
                .font(.subheadline)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .disabled(!carbs.isEmpty || !protein.isEmpty)
                .accessibilityLabel("Fat input field")
            }
            .padding()
            
            Spacer()
            
            Button {
                genieAIVM.getRecipe(method: "initial", kcal: kcal, protein: protein, carbs: carbs, fat: fat)
            } label: {
                Text("Get recipe")
            }
            .accessibilityLabel("Get recipe button")
            .buttonStyle(CTAButton())
            .padding()
        }
    }
}

#Preview {
    GenieAIView()
}
