//
//  Macros.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 20/04/2024.
//

import Foundation

struct Macros: Codable {
    let calories: Double
    let protein: Double
    let carbs: Double
    let fat: Double
}

// Main response structure
struct OpenAIResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let usage: Usage
    let choices: [Choice]
}

// Usage structure
struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

// Choice structure
struct Choice: Codable {
    let message: Message
    let finishReason: String

    enum CodingKeys: String, CodingKey {
        case message
        case finishReason = "finish_reason"
    }
}

// Message structure
struct Message: Codable {
    let role: String
    let content: String
}
