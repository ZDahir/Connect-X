//
//  SettingsView.swift
//  DynaConnect
//
//  Created by Zaid Dahir on 2024-04-22.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var pop
    @ObservedObject var gameSettings: GameSettings
    @State private var isShareSheetPresented = false

    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color(white: 0.05) : Color.comfortWhite)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Form {
                    Section(header: Text("Grid Settings").font(.headline)) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Rows")
                                Spacer()
                                Text("\(gameSettings.rows)")
                            }
                            .font(.title3)
                            .fontWeight(.semibold)
                            
                            Slider(value: Binding(get: {
                                Float(gameSettings.rows)
                            }, set: { value in
                                gameSettings.rows = Int(value)
                            }), in: 4...10)
                            .tint(.green)
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Columns")
                                Spacer()
                                Text("\(gameSettings.columns)")
                            }
                            .font(.title2)
                            .fontWeight(.semibold)
                            
                            Slider(value: Binding(get: {
                                Float(gameSettings.columns)
                            }, set: { value in
                                gameSettings.columns = Int(value)
                            }), in: 4...10)
                            .tint(.green)
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Win Length")
                                Spacer()
                                Text("\(gameSettings.winLength)")
                            }
                            .font(.title2)
                            .fontWeight(.semibold)
                            
                            Slider(value: Binding(get: {
                                Float(gameSettings.winLength)
                            }, set: { value in
                                gameSettings.winLength = Int(value)
                            }), in: 4...10)
                            .tint(.green)
                        }
                    }
                    
                    Section(header: Text("Winning Directions").font(.headline)) {
                        ForEach(GameSettings.Direction.allCases, id: \.self) { direction in
                            HStack {
                                getDirectionImage(direction: direction)
                                    .foregroundColor(.green)
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
                            .font(.title3)
                            .fontWeight(.semibold)
                        }
                    }
                    
                    Section(header: Text("Game Mode").font(.headline)) {
                        Toggle("Player vs Computer", isOn: $gameSettings.isPlayerVsComputer)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    Section(header: Text("Player Names").font(.headline)) {
                        HStack {
                            Text("👨‍💻")
                            TextField("Player 1 Name", text: Binding(
                                get: { gameSettings.playerNames[1] ?? "Player 1" },
                                set: { gameSettings.playerNames[1] = $0 }
                            ))
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                        
                        HStack {
                            if gameSettings.isPlayerVsComputer {
                                Text("💻")
                            } else {
                                Text("👨‍💻")
                            }
                            TextField("Player 2 Name", text: Binding(
                                get: { gameSettings.playerNames[2] ?? "Player 2" },
                                set: { gameSettings.playerNames[2] = $0 }
                            ))
                            .disabled(gameSettings.isPlayerVsComputer)
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                    }
                    
                    Section(header: Text("Piece Colors").font(.headline)) {
                        ColorPicker("Player 1 Color", selection: $gameSettings.player1Color)
                            .font(.title3)
                            .fontWeight(.semibold)
                        ColorPicker("Player 2 Color", selection: $gameSettings.player2Color)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
//                    Section(header: Text("Board Color")) {
//                        ColorPicker("Board Color", selection: $gameSettings.boardColor)
//                            .font(.title3)
//                            .fontWeight(.semibold)
//                    }
                    
                    Section(header: Text("More Options").font(.headline)) {

                        
                        Button(action: openLinktoSource) {
                            HStack {
                                Text("Open Source Code")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                        
                        Button(action: privacyPolicy) {
                            HStack {
                                Text("Privacy Policy")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                        
                        Button(action: shareApp) {
                            HStack {
                                Text("Share the app")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                    }
                }
                .background(Color.clear)
                .scrollContentBackground(.hidden)
                .navigationBarTitle("Settings", displayMode: .inline)
                .sheet(isPresented: $isShareSheetPresented) {
                    ActivityViewController(activityItems: ["Check out this awesome app called Connect X!"])
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.green)
                }
            }
        })
    }
    
    func getDirectionImage(direction: GameSettings.Direction) -> Image {
        switch direction {
        case .horizontal:
            return Image(systemName: "arrow.left.and.right")
        case .vertical:
            return Image(systemName: "arrow.up.and.down")
        case .diagonalUp:
            return Image(systemName: "arrow.up.forward")
        case .diagonalDown:
            return Image(systemName: "arrow.down.forward")
        }
    }

    func privacyPolicy() {
        if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID?action=write-review") {
            UIApplication.shared.open(url)
        }
    }
    
    func openLinktoSource() {
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
