//
//  GeminiDataManager.swift
//  temp_chat_bot
//
//  Created by sookim on 4/22/25.
//

import Foundation

struct GeminiDataManager {

    func responseCorrect(question: String) async throws -> String {
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=\(Bundle.main.geminiAppKey)"

        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: ["contents": ["parts": ["text": question]]], options: [])
        urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            // HTTP 응답 코드 확인
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse(response)
            }

            let decodeData = try JSONDecoder().decode(GeminiDTO.self, from: data)

            // 필요한 데이터가 있는지 확인
            guard let text = decodeData.candidates.first?.content.parts.first?.text else {
                throw DataError.noDataAvailable
            }

            return text
        } catch let decodingError as DecodingError {
            // JSON 디코딩 에러
            throw NetworkError.decodingFailed(decodingError)
        } catch {
            // 기타 모든 에러
            throw NetworkError.unknownError(error)
        }
    }

}

