//
//  CustomNetworkError.swift
//  swiftui_chat
//
//  Created by sookim on 4/22/25.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse(URLResponse?)
    case decodingFailed(DecodingError)
    case unknownError(Error)
}

enum DataError: Error {
    case noDataAvailable
}
