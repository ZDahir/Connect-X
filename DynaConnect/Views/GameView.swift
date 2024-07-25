//
//  GameView.swift
//  DynaConnect
//
//  Created by Zaid Dahir on 2024-04-22.
//

import SwiftUI

struct WinCountStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]), startPoint: .top, endPoint: .bottom)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 2)
                }
            )
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(radius: 5)
    }
}

extension View {
    func winCountStyle() -> some View {
        self.modifier(WinCountStyle())
    }
}

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    tallyView
                    Spacer(minLength: 5)
                    gameBoard(geometry: geometry)
                    Spacer(minLength: 5)
                    gameControls
                    Spacer(minLength: 20)
                }.padding(.all, 10)
            }
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text("Game Over"), message: Text("\(viewModel.gameSettings.playerNames[viewModel.winner!]!) wins!"), dismissButton: .default(Text("OK")))
            }
        }
    }

    private var tallyView: some View {
        HStack {
            Text("\(viewModel.gameSettings.playerNames[1] ?? "Player 1") Wins: \(viewModel.wins[1] ?? 0)").bold()
                .winCountStyle()
            Spacer()
            Text("\(viewModel.gameSettings.playerNames[2] ?? "Player 2") Wins: \(viewModel.wins[2] ?? 0)").bold()
                .winCountStyle()
        }
    }

    private var gameControls: some View {
        VStack(spacing: 10) {
            HStack(spacing: 30) {
                Button("Previous Move") {
                    viewModel.undoMove()
                }
                .buttonStyle(GameButtonStyle())
                
                Button("Reset Wins") {
                    viewModel.resetWins()
                }
                .buttonStyle(GameButtonStyle())
            }
            .frame(maxWidth: .infinity)
            Button("New Game") {
                viewModel.newGame()
            }
            .buttonStyle(GameButtonStyle())
            .frame(maxWidth: .infinity)
        }
    }

    private func gameBoard(geometry: GeometryProxy) -> some View {
        let totalHeight = geometry.size.height * 2 / 3
        let totalWidth = geometry.size.width * 0.9
        let cellSize = min(totalWidth / CGFloat(viewModel.gameSettings.columns), totalHeight / CGFloat(viewModel.gameSettings.rows))
        
        return ZStack {
            VStack(spacing: 0) {
                ForEach(0..<viewModel.board.count, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<viewModel.board[row].count, id: \.self) { column in
                            Circle()
                                .padding(.all, 5)
                                .foregroundColor(getColor(for: row, column: column))
                                .frame(width: cellSize, height: cellSize)
                                .onTapGesture {
                                    viewModel.dropPiece(in: column)
                                }
                        }
                    }
                }
            }
            .background(viewModel.gameSettings.boardColor)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        .frame(width: totalWidth, height: totalHeight)
    }

    private var adBanner: some View {
        Rectangle()
            .frame(height: 50)
            .foregroundColor(.gray)
            .overlay(Text("Ad Banner Here").foregroundColor(.white))
    }

    private func getColor(for row: Int, column: Int) -> Color {
        let value = viewModel.board[row][column]
        return value == 1 ? viewModel.gameSettings.player1Color : (value == 2 ? viewModel.gameSettings.player2Color : .white)
    }
}

struct GameButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]), startPoint: .top, endPoint: .bottom)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 2)
                }
            )
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(radius: configuration.isPressed ? 2 : 5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

extension Color {
    static let lightBlue = Color(red: 245/255, green: 245/255, blue: 245/255)
}
