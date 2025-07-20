//
//  GameState.swift
//  FlagChallenge
//
//  Created by Farhan Ettappurath Sulaiman on 19/07/25.
//

import Foundation
import CoreData

enum GameStatus: Equatable {
    case notStarted
    case scheduled(startTime: Date)
    case startingSoon(countdown: Int)
    case inProgress(questionIndex: Int)
    case betweenQuestions(countdown: Int)
    case finished(score: Int)
}
