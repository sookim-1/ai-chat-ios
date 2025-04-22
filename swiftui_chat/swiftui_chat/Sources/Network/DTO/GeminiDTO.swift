//
//  GeminiDTO.swift
//  swiftui_chat
//
//  Created by sookim on 4/22/25.
//

import Foundation

// MARK: - GeminiDTO
struct GeminiDTO: Codable {
    let candidates: [Candidate]
    let usageMetadata: UsageMetadata
    let modelVersion: String
}

// MARK: - Candidate
struct Candidate: Codable {
    let content: Content
    let finishReason: String
    let avgLogprobs: Double
}

// MARK: - Content
struct Content: Codable {
    let parts: [Part]
    let role: String
}

// MARK: - Part
struct Part: Codable {
    let text: String
}

// MARK: - UsageMetadata
struct UsageMetadata: Codable {
    let promptTokenCount, candidatesTokenCount, totalTokenCount: Int
    let promptTokensDetails, candidatesTokensDetails: [TokensDetail]
}

// MARK: - TokensDetail
struct TokensDetail: Codable {
    let modality: String
    let tokenCount: Int
}
