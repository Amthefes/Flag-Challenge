//
//  Domains.swift
//  FlagChallenge
//
//  Created by Farhan Ettappurath Sulaiman on 19/07/25.
//

import Foundation

struct Country: Codable, Identifiable, Hashable {
    let id: Int
    let countryName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case countryName = "country_name"
    }
}

struct Question: Codable, Identifiable {
    let id = UUID()
    let answerId: Int
    let countries: [Country]
    let countryCode: String
    
    enum CodingKeys: String, CodingKey {
        case answerId = "answer_id"
        case countries
        case countryCode = "country_code"
    }
}

struct QuizData: Codable {
    let questions: [Question]
}
