//
//  BetweenQuestionsView.swift
//  FlagChallenge
//
//  Created by Farhan Ettappurath Sulaiman on 19/07/25.
//

import SwiftUI

struct BetweenQuestionsView: View {
    let countdown: Int
    @State private var bounceEffect = false
    @State private var rotationEffect = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 20) {
                
                Text("Next Question Coming Up")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.white, Color.white.opacity(0.9)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .multilineTextAlignment(.center)
                
                Text("Stay focused and ready!")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            ZStack {
                Circle()
                    .fill(Color.primaryOrange.opacity(0.08))
                    .frame(width: 140, height: 140)
                    .blur(radius: 3)
                    .scaleEffect(bounceEffect ? 1.05 : 1.0)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.1),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 4)
                    .overlay(
                        Circle()
                            .stroke(Color.primaryOrange.opacity(0.5), lineWidth: 2)
                    )
                
                VStack(spacing: 2) {
                    Text(String(format: "%02d", countdown))
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.primaryOrange, Color(hex: "#E64A19")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(bounceEffect ? 1.1 : 1.0)
                    
                    Text("sec")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                        .tracking(1)
                }
            }
            
            HStack(spacing: 8) {
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(
                            index < (5 - countdown)
                            ? Color.primaryOrange
                            : Color.white.opacity(0.3)
                        )
                        .frame(width: 8, height: 8)
                        .scaleEffect(
                            index == (5 - countdown - 1) && bounceEffect ? 1.3 : 1.0
                        )
                }
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .padding(.top, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            startAnimations()
        }
        .onChange(of: countdown) {
            triggerCountdownAnimation()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            bounceEffect = true
        }
        
        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
            rotationEffect = true
        }
    }
    
    private func triggerCountdownAnimation() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        withAnimation(.easeInOut(duration: 0.2)) {
            bounceEffect.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.3)) {
                bounceEffect.toggle()
            }
        }
    }
}
