//
//  Vinhetas_BrasileiraoApp.swift
//  Vinhetas Brasileirao
//
//  Created by Bruno Thuma on 08/10/22.
//

import SwiftUI

@main
struct Vinhetas_BrasileiraoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}