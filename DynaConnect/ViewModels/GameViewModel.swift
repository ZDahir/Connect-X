//
//  GameViewModel.swift
//  DynaConnect
//
//  Created by Zaid Dahir on 2024-04-22.
//

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var board: [[Int]]
        @Published var currentPlayer: Int
        @Published var winner: Int?
        @Published var winningPositions: [(Int, Int)] = []
        @Published var wins: [Int: Int] = [1: 0, 2: 0]
        @Published var showingAlert = false
        @Published var moveHistory: [((Int, Int), Int)] = []
        var gameSettings: GameSettings

        init(gameSettings: GameSettings) {
            self.gameSettings = gameSettings
            self.board = Array(repeating: Array(repeating: 0, count: gameSettings.columns), count: gameSettings.rows)
            self.currentPlayer = 1
        }

    func dropPiece(in column: Int) {
            guard winner == nil, column < gameSettings.columns else { return }

            for row in (0..<gameSettings.rows).reversed() {
                if board[row][column] == 0 {
                    board[row][column] = currentPlayer
                    moveHistory.append(((row, column), currentPlayer))
                    if checkForWin(row: row, column: column) {
                        winner = currentPlayer
                        showingAlert = true
                    } else {
                        currentPlayer = currentPlayer == 1 ? 2 : 1
                    }
                    break
                }
            }
        }

    private func checkForWin(row: Int, column: Int) -> Bool {
        let player = board[row][column]
        let directions = [
            (dx: 0, dy: 1),
            (dx: 1, dy: 0),
            (dx: 1, dy: 1),
            (dx: 1, dy: -1)
        ]
        let neededToWin = gameSettings.winLength
        
        for direction in directions {
            var count = 1

            for step in [-1, 1] {
                for i in 1..<neededToWin {
                    let x = column + i * direction.dx * step
                    let y = row + i * direction.dy * step
                    if x < 0 || x >= gameSettings.columns || y < 0 || y >= gameSettings.rows || board[y][x] != player {
                        break
                    }
                    count += 1
                }
            }

            if count >= neededToWin {
                winningPositions = calculateWinningPositions(startRow: row, startColumn: column, direction: direction, steps: neededToWin)
                return true
            }
        }

        return false
    }

    private func calculateWinningPositions(startRow: Int, startColumn: Int, direction: (dx: Int, dy: Int), steps: Int) -> [(Int, Int)] {
        var positions: [(Int, Int)] = []
        for i in 0..<steps {
            let x = startColumn + i * direction.dx
            let y = startRow + i * direction.dy
            positions.append((y, x))
        }
        return positions
    }

   
    func resetGame() {
            board = Array(repeating: Array(repeating: 0, count: gameSettings.columns), count: gameSettings.rows)
            currentPlayer = 1
            if let win = winner {
                wins[win, default: 0] += 1
            }
            winner = nil
            showingAlert = false
        }
    func undoMove() {
            guard let lastMove = moveHistory.popLast() else { return }
            let (position, _) = lastMove
            board[position.0][position.1] = 0
            currentPlayer = currentPlayer == 1 ? 2 : 1
            winner = nil
        }

        func redoMove() {
        }

        func newGame() {
            board = Array(repeating: Array(repeating: 0, count: gameSettings.columns), count: gameSettings.rows)
            currentPlayer = 1
            winner = nil
            winningPositions = []
            moveHistory = []
            showingAlert = false
        }
}

