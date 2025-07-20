//
//  GameOverView.swift
//  FlagChallenge
//
//  Created by Farhan Ettappurath Sulaiman on 19/07/25.
//

import SwiftUI

struct GameOverView: View {
    let score: Int
    @ObservedObject var viewModel: QuizViewModel
    @State private var showConfetti = false
    @State private var animateScore = false
    @State private var animateElements = false
    
    private var scorePercentage: Double {
        Double(score) / 15.0
    }
    
    private var performanceMessage: String {
        switch scorePercentage {
        case 0.9...:
            return "Outstanding! You're a flag expert! 🏆"
        case 0.7..<0.9:
            return "Great job! You know your flags well! 🌟"
        case 0.5..<0.7:
            return "Good work! Keep practicing! 👍"
        default:
            return "Don't give up! Practice makes perfect! 💪"
        }
    }
    
    private var scoreColor: Color {
        switch scorePercentage {
        case 0.9...:
            return Color.green
        case 0.7..<0.9:
            return Color.primaryOrange
        case 0.5..<0.7:
            return Color.blue
        default:
            return Color.red
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: min(30, geometry.size.height * 0.05)) {
                    Spacer(minLength: min(30, geometry.size.height * 0.05))
                    
                    VStack(spacing: min(20, geometry.size.height * 0.025)) {
                        ZStack {
                            Circle()
                                .fill(scoreColor.opacity(0.2))
                                .frame(width: min(120, geometry.size.width * 0.3), height: min(120, geometry.size.width * 0.3))
                                .blur(radius: 20)
                                .opacity(showConfetti ? 1 : 0)
                            
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            scoreColor.opacity(0.8),
                                            scoreColor,
                                            scoreColor.opacity(0.7)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: min(100, geometry.size.width * 0.25), height: min(100, geometry.size.width * 0.25))
                                .shadow(color: scoreColor.opacity(0.3), radius: 15, x: 0, y: 8)
                                .scaleEffect(animateElements ? 1.0 : 0.8)
                            
                            Image(systemName: scorePercentage >= 0.7 ? "trophy.fill" : "flag.fill")
                                .font(.system(size: min(36, geometry.size.width * 0.09), weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                                .scaleEffect(animateElements ? 1.0 : 0.8)
                        }
                        .rotationEffect(.degrees(showConfetti ? 5 : 0))
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: showConfetti)
                        
                        VStack(spacing: 8) {
                            Text("CHALLENGE COMPLETE")
                                .font(.system(size: min(28, geometry.size.width * 0.07), weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .opacity(animateElements ? 1 : 0)
                                .offset(y: animateElements ? 0 : 20)
                            
                            Text(performanceMessage)
                                .font(.system(size: min(16, geometry.size.width * 0.04), weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .opacity(animateElements ? 1 : 0)
                                .offset(y: animateElements ? 0 : 20)
                        }
                    }
                    
                    VStack(spacing: min(24, geometry.size.height * 0.03)) {
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 8)
                                .frame(width: min(160, geometry.size.width * 0.4), height: min(160, geometry.size.width * 0.4))
                            
                            Circle()
                                .trim(from: 0, to: animateScore ? CGFloat(scorePercentage) : 0)
                                .stroke(
                                    LinearGradient(
                                        colors: [scoreColor, scoreColor.opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                )
                                .frame(width: min(160, geometry.size.width * 0.4), height: min(160, geometry.size.width * 0.4))
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut(duration: 1.5), value: animateScore)
                            
                            VStack(spacing: 4) {
                                Text("\(score)")
                                    .font(.system(size: min(48, geometry.size.width * 0.12), weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .scaleEffect(animateScore ? 1.0 : 0.8)
                                
                                Text("out of 15")
                                    .font(.system(size: min(16, geometry.size.width * 0.04), weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                                    .opacity(animateScore ? 1 : 0)
                            }
                        }
                        
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Accuracy")
                                        .font(.system(size: min(14, geometry.size.width * 0.035)))
                                        .foregroundColor(.white.opacity(0.8))
                                        .fontWeight(.medium)
                                    
                                    Text("\(Int(scorePercentage * 100))%")
                                        .font(.system(size: min(20, geometry.size.width * 0.05), weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("Correct Answers")
                                        .font(.system(size: min(14, geometry.size.width * 0.035)))
                                        .foregroundColor(.white.opacity(0.8))
                                        .fontWeight(.medium)
                                    
                                    Text("\(score)")
                                        .font(.system(size: min(20, geometry.size.width * 0.05), weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(min(20, geometry.size.width * 0.05))
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.1))
                                    .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 4)
                            )
                        }
                        .opacity(animateElements ? 1 : 0)
                        .offset(y: animateElements ? 0 : 30)
                    }
                    .padding(.horizontal, min(20, geometry.size.width * 0.05))
                    
                    Spacer(minLength: min(12, geometry.size.height * 0.015))
                    
                    Button(action: {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.resetGame()
                        }
                    }) {
                        HStack(spacing: 14) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: min(20, geometry.size.width * 0.05)))
                                .fontWeight(.semibold)
                            
                            Text("Play Again")
                                .font(.system(size: min(18, geometry.size.width * 0.045), weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, min(20, geometry.size.height * 0.025))
                        .background(
                            LinearGradient(
                                colors: [Color.primaryOrange, Color(hex: "#E64A19")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(18)
                        .shadow(color: Color.primaryOrange.opacity(0.4), radius: 15, x: 0, y: 8)
                    }
                    .padding(.horizontal, min(20, geometry.size.width * 0.05))
                    .scaleEffect(animateElements ? 1.0 : 0.9)
                    .opacity(animateElements ? 1 : 0)
                    
                    Spacer(minLength: min(10, geometry.size.height * 0.012))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                animateElements = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    animateScore = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                if scorePercentage >= 0.7 {
                    showConfetti = true
                }
            }
        }
    }
}

#Preview {
    GameOverView(score: 12, viewModel: QuizViewModel())
}
