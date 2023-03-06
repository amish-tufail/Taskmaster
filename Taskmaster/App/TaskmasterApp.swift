//
//  TaskmasterApp.swift
//  Taskmaster
//
//  Created by Amish Tufail on 05/03/2023.
//

import SwiftUI

@main
struct TaskmasterApp: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("darkMode") var isDarkMode: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
