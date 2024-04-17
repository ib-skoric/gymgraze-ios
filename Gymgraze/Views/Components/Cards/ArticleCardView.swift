//
//  ArticleCard.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/02/2024.
//

import SwiftUI

struct ArticleCardView: View {
    
    @State var card: ArticleCard
    
    var body: some View {
        GroupBox {
            Image("\(card.image)")
                .resizable()
                .frame(height: 175)
            VStack(alignment: .leading) {
                Text("\(card.title)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text("\(card.subheading)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                Text("\(card.description)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
    }
}

//#Preview {
//    ArticleCard(image: "test", title: "Top 5 testing title", subheading: "Hello world", description: "Hello world again" ).frame(height: 350)
//}
