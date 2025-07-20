//
//  ScheduledView.swift
//  FlagChallenge
//
//  Created by Farhan Ettappurath Sulaiman on 19/07/25.
//

import SwiftUI

struct ScheduledView: View {
    let startTime: Date
    @ObservedObject var viewModel: QuizViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header Section
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.primaryOrange.opacity(0.8), Color.primaryOrange],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: Color.primaryOrange.opacity(0.3), radius: 20, x: 0, y: 8)
                            
                            Image(systemName: "clock.fill")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 8) {
                            Text("Challenge Scheduled")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Your challenge will start at:")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(.bottom, 40)
                    
                    VStack(spacing: 20) {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.title)
                                .foregroundColor(Color.primaryOrange)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(startTime, style: .date)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Text(startTime, style: .time)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.primaryOrange.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
                                )
                        )
                        
                        Text("The challenge will auto start 20 sec before the scheduled time.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    
                    Spacer()
                    
                    // Cancel Button
                    Button(action: {
                        viewModel.resetGame()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                            
                            Text("Cancel Challenge")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.red.opacity(0.9))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 34)
                }
            }
        }
//        .background(
//            LinearGradient(
//                colors: [
//                    Color(hex: "#1A1A2E"),
//                    Color(hex: "#16213E"),
//                    Color(hex: "#0F3460")
//                ],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea(.all)
//        )
    }
}

#Preview {
    ScheduledView(startTime: Date(), viewModel: QuizViewModel())
}
