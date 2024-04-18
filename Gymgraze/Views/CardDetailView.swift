//
//  CardDetailView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 17/04/2024.
//

import SwiftUI

struct CardDetailView: View {
    
    @State var card: ArticleCard
    
    var body: some View {
        NavigationStack {
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

//#Preview {
//    CardDetailView()
//}
