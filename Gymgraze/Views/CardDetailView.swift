//
//  CardDetailView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 17/04/2024.
//

import SwiftUI

struct CardDetailView: View {
    // state variable to hold card data
    @State var card: ArticleCard
    
    var body: some View {
        NavigationStack {
            // show image and text
            Image("\(card.image)")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 175)
                .clipped()
            Text("\(card.body)")
                .font(.body)
                .padding()
            
            Spacer()
        }
        .navigationTitle(card.title)
    }
}
