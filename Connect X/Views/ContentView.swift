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
    
    @State var selectedIndex = 1

    init() {
        let settings = GameSettings()
        _gameSettings = StateObject(wrappedValue: settings)
        _viewModel = StateObject(wrappedValue: GameViewModel(gameSettings: settings))
    }

    var body: some View {
        NavigationView {
            GameView(viewModel: viewModel)
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            SettingsView(gameSettings: gameSettings)
                                .navigationBarBackButtonHidden()
                        } label: {
                            Image(.settingsIcon)
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.green)
                            
                        }
                    }
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
