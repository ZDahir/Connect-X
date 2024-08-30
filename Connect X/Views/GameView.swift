//
//  GameView.swift
//  DynaConnect
//
//  Created by Zaid Dahir on 2024-04-22.
//

import SwiftUI
import AlertToast

struct WinCountStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                Color(hex: "2F3C7E")
            )
            .foregroundColor(.white)
            .cornerRadius(30)
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
    @Environment(\.colorScheme) var colorScheme

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
                }
                .padding(.all, 10)
            }
            .toast(isPresenting: $viewModel.showingAlert) {
                AlertToast(type: .regular, title: "\(viewModel.gameSettings.playerNames[viewModel.winner ?? 0] ?? "") wins!")
            }
        }
        .background(colorScheme == .dark ? Color(white: 0.05) : Color.comfortWhite)
    }

    private var tallyView: some View {
        HStack {
            Text("\(viewModel.wins[1] ?? 0 > viewModel.wins[2] ?? 0 ? "👑" : "") \(viewModel.gameSettings.playerNames[1] ?? "Player 1") Wins: \(viewModel.wins[1] ?? 0)").bold()
                .font(.subheadline)
                .winCountStyle()
            Spacer()
            Text("\(viewModel.wins[2] ?? 0 > viewModel.wins[1] ?? 0 ? "👑" : "") \(viewModel.gameSettings.playerNames[2] ?? "Player 2") Wins: \(viewModel.wins[2] ?? 0)").bold()
                .font(.subheadline)
                .winCountStyle()
        }
    }

    private var gameControls: some View {
        VStack(spacing: 10) {
            HStack(spacing: 30) {
                Button {
                    viewModel.undoMove()
                } label: {
                    HStack {
                        Image(systemName: "arrow.uturn.backward")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text("Previous Move")
                    }
                }
                .buttonStyle(GameButtonStyle())
                
                Button {
                    viewModel.resetWins()
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text("Reset Wins")
                    }
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
        let starFontSize = cellSize * 0.5
        

        return ZStack {
            VStack(spacing: 0) {
                ForEach(0..<viewModel.board.count, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<viewModel.board[row].count, id: \.self) { column in
                            ZStack {
                                Circle()
                                    .padding(.all, 7)
                                    .foregroundColor(getColor(for: row, column: column))
                                    .frame(width: cellSize, height: cellSize)
                                    .onTapGesture {
                                        viewModel.dropPiece(in: column)
                                    }

                                if viewModel.winningPositions.contains(where: { $0 == (row, column) }) {
                                    Text("★")
                                        .font(.system(size: starFontSize))
                                        .foregroundColor(viewModel.gameSettings.starColor)
                                }
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
                Color(hex: "2F3C7E")
            )
            .foregroundColor(.white)
            .cornerRadius(30)
            .shadow(radius: configuration.isPressed ? 2 : 5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

extension Color {
    static let comfortWhite = Color(red: 245/255, green: 245/255, blue: 245/255)
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
