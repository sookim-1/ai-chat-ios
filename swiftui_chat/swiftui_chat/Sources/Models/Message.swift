//
//  Message.swift
//  swiftui_chat
//
//  Created by sookim on 4/22/25.
//

import Foundation
import SwiftData

@Model
final class Message {
    var content: String
    var isUser: Bool
    var timestamp: Date

    init(content: String, isUser: Bool, timestamp: Date) {
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
    }
}
