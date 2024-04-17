//
//  ArticleCard.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 17/04/2024.
//

import Foundation

struct ArticleCard: Codable, Identifiable {
    var id = UUID()
    var image: String
    var title: String
    var subheading: String
    var description: String
    var body: String
}
