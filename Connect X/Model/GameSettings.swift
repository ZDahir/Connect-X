//
//  GameSettings.swift
//  DynaConnect
//
//  Created by Zaid Dahir on 2024-04-22.
//

import SwiftUI

class GameSettings: ObservableObject {
    @Published var rows = 6
    @Published var columns = 7
    @Published var winLength = 4
    @Published var winDirections: [Direction] = [.vertical, .horizontal, .diagonalUp, .diagonalDown]
    @Published var playerNames: [Int: String] = [1: "Player 1", 2: "Player 2"]
    @Published var isPlayerVsComputer: Bool = false {
        didSet {
            playerNames[2] = isPlayerVsComputer ? "Bot" : "Player 2"
        }
    }
    @Published var player1Color: Color = .red
    @Published var player2Color: Color = .yellow
    @Published var boardColor: Color = .blue

    enum Direction: String, CaseIterable, Identifiable {
        case horizontal = "Horizontal"
        case vertical = "Vertical"
        case diagonalUp = "Diagonal Up"
        case diagonalDown = "Diagonal Down"

        var id: String { self.rawValue }
    }
}
