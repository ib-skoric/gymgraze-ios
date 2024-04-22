//
//  GenieAIView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 20/04/2024.
//

import SwiftUI

struct GenieAIView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @ObservedObject var genieAIVM = GenieAIViewModel()
    @State var kcal: String = ""
    @State var carbs: String = ""
    @State var protein: String = ""
    @State var fat: String = ""
    
    var body: some View {
        let goalKcal = userVM.user?.goal?.kcal ?? 0
        let totalKcal = genieAIVM.totalDayKcal
        
        VStack {
            if genieAIVM.isLoading {
                VStack(alignment: .center) {
                    Text("🧞‍♂️")
                        .font(.system(size: 60))
                    
                    Text("Thinking...")
                    ProgressView()
                }
                .padding(.top)
            }
            
            Text("Tell Genie what calories/macros you'd like your recipe to contain")
            
            TextField(text: $kcal) {
                Text("Calories (kcal)")
            }
            .font(.subheadline)
            .fontWeight(.light)
            .multilineTextAlignment(.center)
            .frame(width: 300)
            .keyboardType(.numberPad)
            .textFieldStyle(.roundedBorder)
            
            
            Text("And one of the following...")
            
            TextField(text: $carbs) {
                Text("Carbs (g)")
            }
            .font(.subheadline)
            .fontWeight(.light)
            .multilineTextAlignment(.center)
            .frame(width: 300)
            .keyboardType(.numberPad)
            .textFieldStyle(.roundedBorder)
            .disabled(!protein.isEmpty || !fat.isEmpty)
            
            TextField(text: $protein) {
                Text("Protein (g)")
            }
            .font(.subheadline)
            .fontWeight(.light)
            .multilineTextAlignment(.center)
            .frame(width: 300)
            .keyboardType(.numberPad)
            .textFieldStyle(.roundedBorder)
            .disabled(!carbs.isEmpty || !fat.isEmpty)
            
            TextField(text: $fat) {
                Text("Fat (g)")
            }
            .font(.subheadline)
            .fontWeight(.light)
            .multilineTextAlignment(.center)
            .frame(width: 300)
            .keyboardType(.numberPad)
            .textFieldStyle(.roundedBorder)
            .disabled(!carbs.isEmpty || !protein.isEmpty)
            
            Button {
                genieAIVM.getRecipe(kcal: kcal, protein: protein, carbs: carbs, fat: fat)
            } label: {
                Text("Get recipe")
            }
            .buttonStyle(CTAButtonSmall())
            
        }
        .onAppear {
            genieAIVM.fetchFoodSummary()
        }
    }
}

#Preview {
    GenieAIView()
}
