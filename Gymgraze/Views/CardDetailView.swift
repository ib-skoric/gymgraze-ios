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
        VStack {
            Image("\(card.image)")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 175)
                .clipped()
            VStack(alignment: .leading) {
                Text("\(card.title)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text("\(card.subheading)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                Text("\(card.body)")
                    .font(.body)
            }
        }
    }
}

//#Preview {
//    CardDetailView()
//}
