//
//  Bundle+Extension.swift
//  swiftui_chat
//
//  Created by sookim on 4/22/25.
//

import Foundation

extension Bundle {
    public var geminiAppKey: String {
        return Bundle.main.infoDictionary?["Gemini App Key"] as? String ?? ""
    }
}
