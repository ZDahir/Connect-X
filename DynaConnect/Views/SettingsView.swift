//
//  SettingsView.swift
//  DynaConnect
//
//  Created by Zaid Dahir on 2024-04-22.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var gameSettings: GameSettings

    var body: some View {
        Form {
            Section(header: Text("Grid Settings")) {
                Stepper("Rows: \(gameSettings.rows)", value: $gameSettings.rows, in: 4...10)
                Stepper("Columns: \(gameSettings.columns)", value: $gameSettings.columns, in: 4...10)
                Stepper("Win Length: \(gameSettings.winLength)", value: $gameSettings.winLength, in: 3...10)
            }
            Section(header: Text("Winning Directions")) {
                ForEach(GameSettings.Direction.allCases, id: \.self) { direction in
                    Toggle(direction.rawValue, isOn: Binding(
                        get: { gameSettings.winDirections.contains(direction) },
                        set: { shouldInclude in
                            if shouldInclude {
                                gameSettings.winDirections.append(direction)
                            } else {
                                gameSettings.winDirections.removeAll { $0 == direction }
                            }
                        }
                    ))
                }
            }
        }
        .navigationBarTitle("Settings", displayMode: .inline)
    }
}
