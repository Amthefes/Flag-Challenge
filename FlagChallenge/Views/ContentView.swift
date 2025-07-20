//
//  ContentView.swift
//  FlagsChallengeApp
//
//  Created by Farhan Ettappurath Sulaiman on 19/07/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel = QuizViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: "#1A1A2E"),
                    Color(hex: "#16213E"),
                    Color(hex: "#0F3460")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                VStack {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 0)
                    
                    Text("Flag Challenge")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                }
                .background(
                    LinearGradient(
                        colors: [
                            Color(hex: "#1A1A2E").opacity(0.95),
                            Color(hex: "#16213E").opacity(0.9)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea(.container, edges: .top)
                )
                
                //MARK: Main content
                switch viewModel.currentGameState {
                case .notStarted:
                    ScheduleView(viewModel: viewModel)
                case .scheduled(let startTime):
                    ScheduledView(startTime: startTime, viewModel: viewModel)
                case .startingSoon(let countdown):
                    CountdownView(countdown: countdown)
                case .inProgress(let questionIndex):
                    QuestionView(viewModel: viewModel, questionIndex: questionIndex)
                case .betweenQuestions(let countdown):
                    BetweenQuestionsView(countdown: countdown)
                case .finished(let score):
                    GameOverView(score: score, viewModel: viewModel)
                }
                
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    ContentView()
}
