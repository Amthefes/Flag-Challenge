//
//  CountdownView.swift
//  FlagChallenge
//
//  Created by Farhan Ettappurath Sulaiman on 19/07/25.
//

import SwiftUI

struct CountdownView: View {
    let countdown: Int
    @State private var pulseEffect = false
    @State private var glowEffect = false
    
    var displayCountdown: Int {
        max(0, countdown)
    }
    
    private var countdownColor: Color {
        switch displayCountdown {
        case 0...5:
            return Color.red
        case 6...10:
            return Color.orange
        default:
            return Color.primaryOrange
        }
    }
    
    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            
            VStack(spacing: 20) {
                Text("CHALLENGE STARTING")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.white, Color.white.opacity(0.9)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .tracking(2)
                
                Text("Get ready to test your flag knowledge!")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            ZStack {
                Circle()
                    .fill(countdownColor.opacity(0.1))
                    .frame(width: 220, height: 220)
                    .blur(radius: glowEffect ? 15 : 5)
                    .scaleEffect(glowEffect ? 1.1 : 1.0)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                countdownColor.opacity(0.15),
                                countdownColor.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(pulseEffect ? 1.05 : 1.0)
                    .shadow(color: countdownColor.opacity(0.2), radius: 20, x: 0, y: 10)
                
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                countdownColor,
                                countdownColor.opacity(0.3),
                                countdownColor
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    .frame(width: 180, height: 180)
                    .rotationEffect(.degrees(displayCountdown <= 5 ? 360 : 0))
                
                VStack(spacing: 8) {
                    Text(String(format: "00:%02d", displayCountdown))
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [countdownColor, countdownColor.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: countdownColor.opacity(0.3), radius: 4, x: 0, y: 2)
                        .scaleEffect(displayCountdown <= 3 ? (pulseEffect ? 1.1 : 1.0) : 1.0)
                    
                    Text("SECONDS")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                        .tracking(3)
                }
            }
            
            VStack(spacing: 12) {
                if displayCountdown <= 10 {
                    Text("Almost there...")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(countdownColor)
                        .transition(.opacity.combined(with: .scale))
                } else {
                    Text("Preparing your challenge")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.7))
                        .transition(.opacity.combined(with: .scale))
                }
                
                if displayCountdown <= 5 {
                    Text("Focus and good luck! 🎯")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .animation(.easeInOut(duration: 0.5), value: displayCountdown)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            startAnimations()
        }
        .onChange(of: displayCountdown) {
//            if newValue <= 5 && newValue > 0 {
//
//            }
            triggerUrgentAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            pulseEffect = true
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            glowEffect = true
        }
    }
    
    private func triggerUrgentAnimations() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        
        withAnimation(.easeInOut(duration: 0.3).repeatCount(2, autoreverses: true)) {
            pulseEffect.toggle()
        }
    }
}
