//
//  SettingsView.swift
//  DynaConnect
//
//  Created by Zaid Dahir on 2024-04-22.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var gameSettings: GameSettings
    @State private var isShareSheetPresented = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color(white: 0.05) : Color.comfortWhite) 
                            .edgesIgnoringSafeArea(.all)

            VStack {
                Form {
                    Section(header: Text("Grid Settings")) {
                        Stepper("Rows: \(gameSettings.rows)", value: $gameSettings.rows, in: 4...10)
                        Stepper("Columns: \(gameSettings.columns)", value: $gameSettings.columns, in: 4...10)
                        Stepper("Win Length: \(gameSettings.winLength)", value: $gameSettings.winLength, in: 3...8)
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

                    Section(header: Text("Player Names")) {
                        TextField("Player 1 Name", text: Binding(
                            get: { gameSettings.playerNames[1] ?? "Player 1" },
                            set: { gameSettings.playerNames[1] = $0 }
                        ))
                        TextField("Player 2 Name", text: Binding(
                            get: { gameSettings.playerNames[2] ?? "Player 2" },
                            set: { gameSettings.playerNames[2] = $0 }
                        ))
                        .disabled(gameSettings.isPlayerVsComputer)
                    }

                    Section(header: Text("Game Mode")) {
                        Toggle("Player vs Computer", isOn: $gameSettings.isPlayerVsComputer)
                    }

                    Section(header: Text("Piece Colors")) {
                        ColorPicker("Player 1 Color", selection: $gameSettings.player1Color)
                        ColorPicker("Player 2 Color", selection: $gameSettings.player2Color)
                    }

                    Section(header: Text("Board Color")) {
                        ColorPicker("Board Color", selection: $gameSettings.boardColor)
                    }

                    Section(header: Text("More Options")) {
                        Button(action: leaveARating) {
                            Text("Leave a rating")
                        }
                        Button(action: shareApp) {
                            Text("Share the app")
                        }
                    }
                }
                .background(Color.clear)
                .scrollContentBackground(.hidden)
                .navigationBarTitle("Settings", displayMode: .inline)
                .sheet(isPresented: $isShareSheetPresented) {
                    ActivityViewController(activityItems: ["Check out this awesome app!"])
                }
            }
        }
    }

    func leaveARating() {
        if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID?action=write-review") {
            UIApplication.shared.open(url)
        }
    }

    func shareApp() {
        isShareSheetPresented = true
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}
