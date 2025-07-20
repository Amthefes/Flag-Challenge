//
//  QuestionView.swift
//  FlagChallenge
//
//  Created by Farhan Ettappurath Sulaiman on 19/07/25.
//

import SwiftUI

struct QuestionView: View {
    @ObservedObject var viewModel: QuizViewModel
    let questionIndex: Int
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Question \(questionIndex + 1)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("of \(viewModel.questions.count)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 4)
                            .frame(width: 50, height: 50)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(viewModel.timeRemaining) / 30)
                            .stroke(
                                viewModel.timeRemaining <= 5
                                ? Color.red
                                : Color.primaryOrange,
                                style: StrokeStyle(lineWidth: 4, lineCap: .round)
                            )
                            .frame(width: 50, height: 50)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 0.3), value: viewModel.timeRemaining)
                        
                        Text("\(viewModel.timeRemaining)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                VStack(spacing: 8) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 6)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.primaryOrange, Color(hex: "#E64A19")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: geo.size.width * CGFloat(questionIndex + 1) / CGFloat(viewModel.questions.count),
                                    height: 6
                                )
                                .animation(.easeInOut(duration: 0.3), value: questionIndex)
                        }
                    }
                    .frame(height: 6)
                    .padding(.horizontal, 20)
                }
                
                VStack(spacing: 16) {
                    Text("Guess the country from the flag ?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    if let question = viewModel.currentQuestion(),
                       let flagImage = viewModel.getFlagImage(for: question.countryCode) {
                        
                        VStack(spacing: 24) {
                            ZStack {
                                Image(uiImage: flagImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            .padding(.horizontal, 40)
                            
                            VStack(spacing: 12) {
                                ForEach(question.countries, id: \.id) { country in
                                    AnswerButton(
                                        country: country,
                                        viewModel: viewModel,
                                        isCorrect: question.answerId == country.id
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.horizontal, 8)
                
                Spacer(minLength: 20)
            }
            .padding(.bottom, 20)
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
        .onAppear {
            viewModel.startQuestionTimer(questionIndex: questionIndex)
        }
        .onDisappear {
            viewModel.questionTimer?.invalidate()
        }
    }
}

#Preview {
    QuestionView(viewModel: QuizViewModel(), questionIndex: 1)
}
