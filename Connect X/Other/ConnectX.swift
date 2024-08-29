//
//  DynaConnectApp.swift
//  DynaConnect
//
//  Created by Zaid Dahir on 2024-04-22.
//

import SwiftUI
import SwiftData
import AlertToast

@main
struct ConnectX: App {
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete = false
    @State var showAlert = false

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Item.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            VStack {
                if isOnboardingComplete {
                    ContentView()
                        .navigationViewStyle(StackNavigationViewStyle())
                } else {
                    OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                }
            }
            .toast(isPresenting: $showAlert) {
                AlertToast(displayMode: .alert, type: .complete(.green), title: "Connect X")
            }
            .onChange(of: isOnboardingComplete) { oldValue, newValue in
                if newValue {
                    showAlert = true
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
