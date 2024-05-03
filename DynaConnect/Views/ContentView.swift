//
//  ContentView.swift
//  DynaConnect
//
//  Created by Zaid Dahir on 2024-04-22.
//


import SwiftUI

struct ContentView: View {
    @StateObject var gameSettings = GameSettings()
    @StateObject var viewModel: GameViewModel  

    init() {
        let settings = GameSettings()
        _gameSettings = StateObject(wrappedValue: settings)
        _viewModel = StateObject(wrappedValue: GameViewModel(gameSettings: settings))
    }

    var body: some View {
        TabView {
            GameView(viewModel: viewModel)
                .tabItem {
                    Label("Game", systemImage: "gamecontroller")
                }
            SettingsView(gameSettings: gameSettings)
                .tabItem {
                    Label("Settings", systemImage: "slider.horizontal.3")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
