//
//  GameViewModel.swift
//  DynaConnect
//
//  Created by Zaid Dahir on 2024-04-22.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var board: [[Int]]
    @Published var currentPlayer: Int
    @Published var winner: Int?
    @Published var winningPositions: [(Int, Int)] = []
    @Published var wins: [Int: Int] = [1: 0, 2: 0]
    @Published var showingAlert = false
    @Published var isAnimating = false
    @Published var moveHistory: [((Int, Int), Int)] = []
    var gameSettings: GameSettings

    init(gameSettings: GameSettings) {
        self.gameSettings = gameSettings
        self.board = Array(repeating: Array(repeating: 0, count: gameSettings.columns), count: gameSettings.rows)
        self.currentPlayer = 1
    }

    func dropPiece(in column: Int) {
        guard winner == nil, column < gameSettings.columns, !isAnimating else { return }

        for row in (0..<gameSettings.rows).reversed() {
            if board[row][column] == 0 {
                isAnimating = true
                animatePieceDrop(to: (row, column))
                break
            }
        }
    }

    private func animatePieceDrop(to destination: (Int, Int)) {
        var currentRow = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if currentRow > destination.0 {
                timer.invalidate()
                self.board[destination.0][destination.1] = self.currentPlayer
                self.moveHistory.append((destination, self.currentPlayer))
                self.isAnimating = false

                if self.checkForWin(row: destination.0, column: destination.1) {
                    self.winner = self.currentPlayer
                    self.showingAlert = true
                    self.wins[self.currentPlayer, default: 0] += 1
                } else {
                    self.currentPlayer = self.currentPlayer == 1 ? 2 : 1
                    if self.gameSettings.isPlayerVsComputer && self.currentPlayer == 2 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.computerMove()
                        }
                    }
                }
                return
            }
            if currentRow > 0 {
                self.board[currentRow - 1][destination.1] = 0
            }
            self.board[currentRow][destination.1] = self.currentPlayer
            currentRow += 1
        }
    }

    private func computerMove() {
        var availableColumns: [Int] = []
        for column in 0..<gameSettings.columns {
            if board[0][column] == 0 {
                availableColumns.append(column)
            }
        }

        if let column = availableColumns.randomElement() {
            dropPiece(in: column)
        }
    }

    private func directionOffsets(for direction: GameSettings.Direction) -> (dx: Int, dy: Int) {
        switch direction {
        case .horizontal:
            return (dx: 1, dy: 0)
        case .vertical:
            return (dx: 0, dy: 1)
        case .diagonalUp:
            return (dx: 1, dy: -1)
        case .diagonalDown:
            return (dx: 1, dy: 1)
        }
    }

    private func checkForWin(row: Int, column: Int) -> Bool {
        let player = board[row][column]
        let neededToWin = gameSettings.winLength

        for direction in gameSettings.winDirections {
            let offsets = directionOffsets(for: direction)
            var count = 1

            for step in [-1, 1] {
                for i in 1..<neededToWin {
                    let x = column + i * offsets.dx * step
                    let y = row + i * offsets.dy * step
                    if x < 0 || x >= gameSettings.columns || y < 0 || y >= gameSettings.rows || board[y][x] != player {
                        break
                    }
                    count += 1
                }
            }

            if count >= neededToWin {
                winningPositions = calculateWinningPositions(startRow: row, startColumn: column, direction: offsets, steps: neededToWin)
                
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
        winner = nil
        showingAlert = false
        moveHistory = []
    }

    func resetWins() {
        wins = [1: 0, 2: 0]
    }

    func undoMove() {
        guard let lastMove = moveHistory.popLast() else { return }
        let (position, _) = lastMove
        board[position.0][position.1] = 0
        currentPlayer = currentPlayer == 1 ? 2 : 1
        winner = nil
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
