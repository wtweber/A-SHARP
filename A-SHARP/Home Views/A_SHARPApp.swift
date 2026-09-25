//
//  A_SHARPApp.swift
//  A-SHARP
//
//  Created by William Weber on 1/26/26.
//

import SwiftUI
import SwiftData

@main
struct A_SHARPApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Flight.self,
            Airport.self,
            Aircraft.self,
            Landing.self,
            Approach.self,
            Import.self,
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
            GeometryReader { geometry in
                ContentView()
                    .environment(\.windowSize, geometry.size)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
