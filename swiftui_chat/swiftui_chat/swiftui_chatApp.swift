//
//  swiftui_chatApp.swift
//  swiftui_chat
//
//  Created by sookim on 4/22/25.
//

import SwiftUI
import SwiftData

@main
struct swiftui_chatApp: App {

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()


    var body: some Scene {
        WindowGroup {
            NavigationView {
                RecentView()
            }
            .navigationBarHidden(true)
            .modelContainer(sharedModelContainer)
        }
    }
}
