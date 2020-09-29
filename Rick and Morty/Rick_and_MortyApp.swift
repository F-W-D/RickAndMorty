//
//  Rick_and_MortyApp.swift
//  Rick and Morty
//
//  Created by PJ Gutierrez on 9/29/20.
//

import SwiftUI

@main
struct Rick_and_MortyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
