//
//  AnswerButton.swift
//  FlagChallenge
//
//  Created by Farhan Ettappurath Sulaiman on 19/07/25.
//

import SwiftUI

struct AnswerButton: View {
    let country: Country
    @ObservedObject var viewModel: QuizViewModel
    let isCorrect: Bool
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                viewModel.selectAnswer(country.id)
            }
        }) {
            HStack(spacing: 16) {
                Text(country.countryName)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Group {
                        if viewModel.selectedAnswer == country.id {
                            Text(viewModel.isCorrect ? "Correct" : "Wrong")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(viewModel.isCorrect ? .green : .red)
                            
                            Image(systemName: viewModel.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(viewModel.isCorrect ? .green : .red)
                                .scaleEffect(1.1)
                        } else if viewModel.showResult && isCorrect {
                            Text("Correct")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.green)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        } else {
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                .frame(width: 24, height: 24)
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
            .background(backgroundForButton)
            .overlay(borderForButton)
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .disabled(viewModel.selectedAnswer != nil || viewModel.showResult)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    private var textColor: Color {
        if viewModel.selectedAnswer == country.id {
            return viewModel.isCorrect ? .green : .red
        } else if viewModel.showResult && isCorrect {
            return .green
        } else {
            return .white
        }
    }
    
    private var backgroundForButton: some View {
        Group {
            if viewModel.selectedAnswer == country.id {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        viewModel.isCorrect
                        ? Color.green.opacity(0.2)
                        : Color.red.opacity(0.2)
                    )
            } else if viewModel.showResult && isCorrect {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.green.opacity(0.2))
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.08))
            }
        }
    }
    
    private var borderForButton: some View {
        Group {
            if viewModel.selectedAnswer == country.id {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        viewModel.isCorrect ? Color.green : Color.red,
                        lineWidth: 2
                    )
            } else if viewModel.showResult && isCorrect {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.green, lineWidth: 2)
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            }
        }
    }
}
