//
//  ArticleCard.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/02/2024.
//

import SwiftUI

struct ArticleCard: View {
    
    var image: String
    var title: String
    var subheading: String
    var description: String
    
    var body: some View {
        VStack {
            Image("\(image)")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 175)
                .clipped()
            VStack(alignment: .leading) {
                Text("\(title)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text("\(subheading)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                Text("\(description)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
    }
}

#Preview {
    ArticleCard(image: "test", title: "Top 5 testing title", subheading: "Hello world", description: "Hello world again" ).frame(height: 350)
}
