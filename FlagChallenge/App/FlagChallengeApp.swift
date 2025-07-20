//
//  FlagChallengeApp.swift
//  FlagChallenge
//
//  Created by Farhan Ettappurath Sulaiman on 19/07/25.
//

import SwiftUI

@main
struct FlagChallengeApp: App {
    let persistenceController = GameDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.context)
        }
    }
}
