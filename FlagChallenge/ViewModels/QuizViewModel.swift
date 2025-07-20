//
//  QuizViewModel.swift
//  FlagChallenge
//
//  Created by Farhan Ettappurath Sulaiman on 19/07/25.
//

import Foundation
import Combine
import UIKit

class QuizViewModel: ObservableObject {
    @Published var currentGameState: GameStatus = .notStarted
    @Published var scheduledTime: Date?
    @Published var questions: [Question] = [] {
        didSet {
            self.quationsCount = questions.count
        }
    }
    @Published var selectedAnswer: Int?
    @Published var showResult: Bool = false
    @Published var isCorrect: Bool = false
    @Published var timeRemaining: Int = 30
    
    private var gameTimer: AnyCancellable?
    private var countdownTimer: AnyCancellable?
    private var betweenQuestionsTimer: AnyCancellable?
    private(set) var questionTimer: Timer?
    
    private var currentQuestionIndex: Int = 0
    private var score: Int = 0
    private var timer: AnyCancellable?
    private(set) var quationsCount: Int = 0
    
    init() {
        loadQuestions()
        loadSavedGame()
    }
    
    private func loadQuestions() {
        if let url = Bundle.main.url(forResource: "question", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let quizData = try decoder.decode(QuizData.self, from: data)
                self.questions = quizData.questions
            } catch {
                print("Error loading questions: \(error)")
            }
        } else {
            print("Couldn't find question.json in bundle")
        }
    }
    
    private func loadSavedGame() {
        if let savedState = GameDataManager.shared.loadGameState() {
            self.scheduledTime = savedState.scheduledTime
            self.score = savedState.score
            
            if let scheduledTime = scheduledTime {
                let now = Date()
                if scheduledTime > now {
                    let timeUntilStart = Int(scheduledTime.timeIntervalSince(now))
                    if timeUntilStart <= 20 {
                        startCountdown(timeUntilStart)
                    } else {
                        currentGameState = .scheduled(startTime: scheduledTime)
                        startScheduledTimer(startTime: scheduledTime)
                    }
                } else {
                    let timeSinceStart = Int(now.timeIntervalSince(scheduledTime))
                    let totalGameTime = self.quationsCount * 30 + 14 * 10
                    
                    if timeSinceStart >= totalGameTime {
                        currentGameState = .finished(score: score)
                    } else {
                        let questionAndTime = calculateCurrentQuestion(timeSinceStart: timeSinceStart)
                        currentQuestionIndex = questionAndTime.questionIndex
                        timeRemaining = questionAndTime.timeRemaining
                        
                        if questionAndTime.isBetweenQuestions {
                            startBetweenQuestionsTimer(countdown: timeRemaining)
                        } else {
                            startQuestionTimer(questionIndex: currentQuestionIndex)
                        }
                    }
                }
            }
        }
    }
    
    private func calculateCurrentQuestion(timeSinceStart: Int) -> (questionIndex: Int, timeRemaining: Int, isBetweenQuestions: Bool) {
        var remainingTime = timeSinceStart
        var questionIndex = 0
        
        while questionIndex < self.quationsCount {
            if remainingTime < 30 {
                return (questionIndex, 30 - remainingTime, false)
            }
            remainingTime -= 30
            
            if questionIndex < 14 {
                if remainingTime < 10 {
                    return (questionIndex + 1, 10 - remainingTime, true)
                }
                remainingTime -= 10
            }
            
            questionIndex += 1
        }
        
        return (14, 0, false)
    }
    
    func scheduleGame(startTime: Date) {
        scheduledTime = startTime
        GameDataManager.shared.saveGameState(
            currentQuestion: 0,
            timeRemaining: 0,
            scheduledTime: startTime,
            score: 0
        )
        
        let now = Date()
        let timeUntilStart = Int(startTime.timeIntervalSince(now))
        
        if timeUntilStart <= 20 {
            startCountdown(timeUntilStart)
        } else {
            currentGameState = .scheduled(startTime: startTime)
            startScheduledTimer(startTime: startTime)
        }
    }
    
    private func startScheduledTimer(startTime: Date) {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                let now = Date()
                let timeUntilStart = Int(startTime.timeIntervalSince(now))
                
                if timeUntilStart <= 20 {
                    self.timer?.cancel()
                    self.startCountdown(timeUntilStart)
                }
            }
    }
    
    private func startCountdown(_ seconds: Int) {
        var countdown = max(0, seconds)
        currentGameState = .startingSoon(countdown: countdown)
        
        countdownTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                countdown -= 1
                countdown = max(0, countdown)
                self.currentGameState = .startingSoon(countdown: countdown)
                
                if countdown <= 0 {
                    self.countdownTimer?.cancel()
                    self.startGame()
                }
            }
    }
    
    private func startGame() {
        currentQuestionIndex = 0
        score = 0
        startQuestionTimer(questionIndex: 0)
    }
    
    public func startQuestionTimer(questionIndex: Int) {
        // Reset timer state
        timeRemaining = 30
        selectedAnswer = nil
        showResult = false
        isCorrect = false
        
        questionTimer?.invalidate()
        
        currentGameState = .inProgress(questionIndex: questionIndex)
        
        GameDataManager.shared.saveGameState(
            currentQuestion: questionIndex,
            timeRemaining: timeRemaining,
            scheduledTime: scheduledTime,
            score: score
        )
        
        // Start new timer
        questionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.timeRemaining -= 1
            self.timeRemaining = max(0, self.timeRemaining)
            
            if self.timeRemaining <= 0 {
                self.questionTimer?.invalidate()
                self.handleTimeExpired()
            }
        }
    }
    
    private func handleTimeExpired() {
        showResult = true
        isCorrect = false
        
        GameDataManager.shared.saveGameState(
            currentQuestion: currentQuestionIndex,
            timeRemaining: 0,
            scheduledTime: scheduledTime,
            score: score
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.moveToNextQuestionOrBreak()
        }
    }
    
    private func startBetweenQuestionsTimer(countdown: Int) {
        var remainingCountdown = max(0, countdown)
        currentGameState = .betweenQuestions(countdown: remainingCountdown)
        
        betweenQuestionsTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                remainingCountdown -= 1
                remainingCountdown = max(0, remainingCountdown)
                self.currentGameState = .betweenQuestions(countdown: remainingCountdown)
                
                if remainingCountdown <= 0 {
                    self.betweenQuestionsTimer?.cancel()
                    self.startQuestionTimer(questionIndex: self.currentQuestionIndex)
                }
            }
    }
    
    private func moveToNextQuestionOrBreak() {
        if currentQuestionIndex < 14 {
            currentQuestionIndex += 1
            startBetweenQuestionsTimer(countdown: 10)
        } else {
            endGame()
        }
    }
    
    func selectAnswer(_ answerId: Int) {
        guard selectedAnswer == nil else { return }
        
        questionTimer?.invalidate()
        
        selectedAnswer = answerId
        let currentQuestion = questions[currentQuestionIndex]
        isCorrect = answerId == currentQuestion.answerId
        
        if isCorrect {
            score += 1
        }
        
        showResult = true
        
        GameDataManager.shared.saveGameState(
            currentQuestion: currentQuestionIndex,
            timeRemaining: timeRemaining,
            scheduledTime: scheduledTime,
            score: score
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.moveToNextQuestionOrBreak()
        }
    }
    
    private func endGame() {
        currentGameState = .finished(score: score)
        GameDataManager.shared.resetGameState()
    }
    
    func resetGame() {
        timer?.cancel()
        questionTimer?.invalidate()
        gameTimer?.cancel()
        countdownTimer?.cancel()
        betweenQuestionsTimer?.cancel()
        
        currentGameState = .notStarted
        scheduledTime = nil
        selectedAnswer = nil
        showResult = false
        isCorrect = false
        currentQuestionIndex = 0
        score = 0
        timeRemaining = 30
        
        GameDataManager.shared.resetGameState()
    }
    
    func currentQuestion() -> Question? {
        guard questions.indices.contains(currentQuestionIndex) else { return nil }
        return questions[currentQuestionIndex]
    }
    
    func getFlagImage(for countryCode: String) -> UIImage? {
        UIImage(named: countryCode.uppercased())
    }
}
