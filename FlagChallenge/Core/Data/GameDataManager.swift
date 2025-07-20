//
//  GameDataManager.swift
//  FlagChallenge
//
//  Created by Farhan Ettappurath Sulaiman on 19/07/25.
//

import CoreData

class GameDataManager {
    static let shared = GameDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FlagsChallenge")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: GameState FUnctions
    func saveGameState(currentQuestion: Int, timeRemaining: Int, scheduledTime: Date?, score: Int) {
        let fetchRequest: NSFetchRequest<GameState> = GameState.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            let gameState = results.first ?? GameState(context: context)
            
            gameState.currentQuestion = Int16(currentQuestion)
            gameState.timeRemaining = Int16(timeRemaining)
            gameState.scheduledTime = scheduledTime
            gameState.score = Int16(score)
            
            saveContext()
        } catch {
            print("Error saving game state: \(error)")
        }
    }
    
    func loadGameState() -> (currentQuestion: Int, timeRemaining: Int, scheduledTime: Date?, score: Int)? {
        let fetchRequest: NSFetchRequest<GameState> = GameState.fetchRequest()
        
        do {
            if let gameState = try context.fetch(fetchRequest).first {
                return (
                    currentQuestion: Int(gameState.currentQuestion),
                    timeRemaining: Int(gameState.timeRemaining),
                    scheduledTime: gameState.scheduledTime,
                    score: Int(gameState.score)
                )
            }
            return nil
        } catch {
            print("Error loading game state: \(error)")
            return nil
        }
    }
    
    func resetGameState() {
        let fetchRequest: NSFetchRequest<GameState> = GameState.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            for gameState in results {
                context.delete(gameState)
            }
            saveContext()
        } catch {
            print("Error resetting game state: \(error)")
        }
    }
}
