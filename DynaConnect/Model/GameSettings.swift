//
//  GameSettings.swift
//  DynaConnect
//
//  Created by Zaid Dahir on 2024-04-22.
//

import Foundation

class GameSettings: ObservableObject {
    @Published var rows: Int = 6
    @Published var columns: Int = 7
    @Published var winLength: Int = 4
    @Published var winDirections: [Direction] = [.vertical, .horizontal, .diagonalUp, .diagonalDown]

    enum Direction: String, CaseIterable, Identifiable {
        case horizontal = "Horizontal"
        case vertical = "Vertical"
        case diagonalUp = "Diagonal Up"
        case diagonalDown = "Diagonal Down"

        var id: String { self.rawValue }
    }
}
