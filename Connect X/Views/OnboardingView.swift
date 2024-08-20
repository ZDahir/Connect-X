//
//  OnboardingView.swift
//  DynaConnect
//
//  Created by Zaid Dahir on 2024-08-09.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isOnboardingComplete: Bool
    @State private var gridColor = Color.blue
    @State private var pieceColors: [[Color]] = []
    @State private var currentTab = 0
    @State private var currentGridSizeIndex = 0
    @State private var isLoading = true // Loading state

    let colors: [Color] = [.blue, .green, .orange, .purple, .pink]
    let gridSizes: [(rows: Int, columns: Int)] = [(4, 4), (6, 7), (8, 9)]
    let pieceColorSets: [[Color]] = [
        [.red, .yellow, .green, .blue],
        [.orange, .purple, .blue, .pink],
        [.yellow, .green, .red, .purple]
    ]

    var body: some View {
        ZStack {
            if isLoading {
                loadingView // Display loading view initially
            } else {
                TabView(selection: $currentTab) {
                    welcomeSlide.tag(0)
                    gridAnimationSlide.tag(1)
                    pieceAnimationSlide.tag(2)
                    gridSizeSlide.tag(3)
                }
                .tabViewStyle(PageTabViewStyle())
                .onAppear {
                    startGridColorAnimation()
                    startPieceColorAnimation()
                    startGridSizeAnimation()
                }
            }
        }
        .onAppear {
            initializePieceColors()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isLoading = false
            }
            
            if colorScheme == .light {
                UIPageControl.appearance().currentPageIndicatorTintColor = .black
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
            } else {
                UIPageControl.appearance().currentPageIndicatorTintColor = .white
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.2)
            }
        }
        .onChange(of: colorScheme) { value1, value2 in
            if colorScheme == .light {
                UIPageControl.appearance().currentPageIndicatorTintColor = .black
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
            } else {
                UIPageControl.appearance().currentPageIndicatorTintColor = .white
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.2)
            }
        }
    }

    private var loadingView: some View {
        VStack {
            ProgressView() // Add a progress indicator
                .scaleEffect(1.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }

    private var welcomeSlide: some View {
        VStack(spacing: 20) {
            appIcon
                .padding(.top)
            
            Text("X in a Row!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Play on grids from 4x4 to 8x9, choose the number of pieces needed to win, and set horizontal, vertical, or diagonal win directions. The rules are in your hands!")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .font(.body)
                .padding()
            
            

            continueButton
        }
        .tabItem {
            Image(systemName: "1.circle")
            Text("Welcome")
        }
    }
    private var gridAnimationSlide: some View {
        VStack(spacing: 20) {
            Text("Dynamic Grid Colors")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            Text("Watch the grid come to life with changing colors.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .font(.body)

            animatedConnectFourGrid
                .padding()

            continueButton
        }
        .tabItem {
            Image(systemName: "2.circle")
            Text("Grid Colors")
        }
    }

    private var pieceAnimationSlide: some View {
        VStack(spacing: 20) {
            Text("Colorful Game Pieces")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            Text("Enjoy the vibrant pieces during the game.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .font(.body)

            animatedConnectFourPieces
                .padding()

            continueButton
        }
        .tabItem {
            Image(systemName: "3.circle")
            Text("Piece Colors")
        }
    }

    private var gridSizeSlide: some View {
        VStack(spacing: 20) {
            Text("Customizable Grid Sizes")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            Text("Adjust the grid size to suit your play style.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .font(.body)

            animatedConnectFourGridWithSize
                .padding()

            playNowButton
        }
        .tabItem {
            Image(systemName: "4.circle")
            Text("Grid Sizes")
        }
    }

    private var continueButton: some View {
        Button(action: {
            currentTab += 1
        }) {
            Text("Continue")
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(30)
        }
        .padding()
    }

    private var playNowButton: some View {
        Button(action: {
            isOnboardingComplete = true
        }) {
            Text("Play Now")
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(30)
        }
        .padding()
    }

    private var animatedConnectFourGrid: some View {
        GeometryReader { geometry in
            let cellSize = min(geometry.size.width / CGFloat(gridSizes[1].columns), geometry.size.height / CGFloat(gridSizes[1].rows))
            VStack(spacing: 0) {
                ForEach(0..<gridSizes[1].rows, id: \.self) { _ in
                    HStack(spacing: 0) {
                        ForEach(0..<gridSizes[1].columns, id: \.self) { _ in
                            Circle()
                                .padding(.all, 5)
                                .foregroundColor(.white)
                                .frame(width: cellSize, height: cellSize)
                        }
                    }
                }
            }
            .background(gridColor)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private var animatedConnectFourPieces: some View {
        GeometryReader { geometry in
            let cellSize = min(geometry.size.width / CGFloat(gridSizes[1].columns), geometry.size.height / CGFloat(gridSizes[1].rows))
            VStack(spacing: 0) {
                ForEach(0..<gridSizes[1].rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<gridSizes[1].columns, id: \.self) { column in
                            Circle()
                                .padding(.all, 5)
                                .foregroundColor(pieceColors[row][column])
                                .frame(width: cellSize, height: cellSize)
                        }
                    }
                }
            }
            .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private var animatedConnectFourGridWithSize: some View {
        GeometryReader { geometry in
            let currentSize = gridSizes[currentGridSizeIndex]
            let cellSize = min(geometry.size.width / CGFloat(currentSize.columns), geometry.size.height / CGFloat(currentSize.rows))
            VStack(spacing: 0) {
                ForEach(0..<currentSize.rows, id: \.self) { _ in
                    HStack(spacing: 0) {
                        ForEach(0..<currentSize.columns, id: \.self) { _ in
                            Circle()
                                .padding(.all, 5)
                                .foregroundColor(.white)
                                .frame(width: cellSize, height: cellSize)
                        }
                    }
                }
            }
            .background(Color.blue)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private var appIcon: some View {
        VStack(spacing: 0) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { column in
                        Circle()
                            .padding(5)
                            .foregroundColor((row + column) % 2 == 1 ? .white : .red)
                            .frame(width: 30, height: 30)
                    }
                }
            }
        }
        .background(Color.blue)
        .cornerRadius(8)
        .shadow(radius: 5)
    }

    private func startGridColorAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                gridColor = colors.randomElement() ?? Color.blue
            }
        }
    }

    private func startPieceColorAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                let newColors = pieceColorSets.randomElement() ?? pieceColorSets[0]
                for row in 0..<pieceColors.count {
                    for column in 0..<pieceColors[row].count {
                        pieceColors[row][column] = newColors[column % newColors.count]
                    }
                }
            }
        }
    }

    private func startGridSizeAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                currentGridSizeIndex = (currentGridSizeIndex + 1) % gridSizes.count
            }
        }
    }

    private func initializePieceColors() {
        let rows = gridSizes[1].rows
        let columns = gridSizes[1].columns
        let initialColors = pieceColorSets[0]

        pieceColors = Array(repeating: Array(repeating: initialColors[0], count: columns), count: rows)

        for row in 0..<rows {
            for column in 0..<columns {
                pieceColors[row][column] = initialColors[column % initialColors.count]
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isOnboardingComplete: .constant(false))
    }
}
