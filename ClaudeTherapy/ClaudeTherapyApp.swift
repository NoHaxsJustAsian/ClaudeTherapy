//
//  ClaudeTherapyApp.swift
//  ClaudeTherapy
//
//  Created by Win Tongtawee on 11/19/24.
//

import SwiftUI

@main
struct ClaudeTherapyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
