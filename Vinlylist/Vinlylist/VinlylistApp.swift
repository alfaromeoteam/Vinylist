//
//  VinlylistApp.swift
//  Vinlylist
//
//  Created by Matteo Pidalà on 19/04/25.
//

import SwiftUI

@main
struct VinlylistApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
