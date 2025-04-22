//
//  Item.swift
//  swiftui_chat
//
//  Created by sookim on 4/22/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    @Attribute(.unique) var chatRoomId: UUID
    var title: String
    @Relationship var chatMessage: [Message]
    var timestamp: Date

    init(chatRoomId: UUID = UUID(), title: String, chatMessage: [Message], timestamp: Date) {
        self.chatRoomId = chatRoomId
        self.title = title
        self.chatMessage = chatMessage
        self.timestamp = timestamp
    }
}
