//
//  GameView.swift
//  DynaConnect
//
//  Created by Zaid Dahir on 2024-04-22.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                tallyView.padding(.top, 20)

                Spacer(minLength: 20)

                gameBoard(geometry: geometry)

                moveControls.padding()

                newGameButton.padding()

                adBanner
            }
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text("Game Over"), message: Text("Player \(viewModel.winner!) wins!"), dismissButton: .default(Text("OK")))
        }
    }

    private var tallyView: some View {
        HStack {
            Text("Player 1 Wins: \(viewModel.wins[1] ?? 0)").bold()
            Spacer()
            Text("Player 2 Wins: \(viewModel.wins[2] ?? 0)").bold()
        }
    }

    private var moveControls: some View {
        HStack {
            Button("Previous Move") {
                viewModel.undoMove()
            }
            .buttonStyle(GameButtonStyle())

            Spacer()

            Button("Next Move") {
                viewModel.redoMove()
            }
            .buttonStyle(GameButtonStyle())
        }
    }

    private var newGameButton: some View {
        Button("New Game") {
            viewModel.newGame()
        }
        .buttonStyle(GameButtonStyle())
    }

    private func gameBoard(geometry: GeometryProxy) -> some View {
        let totalHeight = geometry.size.height * 2 / 3
        let totalWidth = geometry.size.width - 40
        let cellSize = min(totalWidth / CGFloat(viewModel.gameSettings.columns), totalHeight / CGFloat(viewModel.gameSettings.rows))

        return VStack(spacing: 0) {
            ForEach(0..<viewModel.board.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<viewModel.board[row].count, id: \.self) { column in
                        Circle()
                            .foregroundColor(getColor(for: row, column: column))
                            .frame(width: cellSize * 0.9, height: cellSize * 0.9)
                            .padding(2)
                            .background(Color.blue)
                            .onTapGesture {
                                viewModel.dropPiece(in: column)
                            }
                    }
                }
            }
            .background(Color.blue)
        }
    }

    private var adBanner: some View {
        Rectangle()
            .frame(height: 50)
            .foregroundColor(.gray)
            .overlay(Text("Ad Banner Here").foregroundColor(.white))
    }

    private func getColor(for row: Int, column: Int) -> Color {
        let value = viewModel.board[row][column]
        return value == 1 ? .red : (value == 2 ? .yellow : .white)
    }
}


struct GameButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
