

import Foundation
import SwiftUI

class QuestViewModel: ObservableObject {
    @Published var currentRiddleIndex = 0
    @Published var selectedIndex: Int? = nil
    @Published var showResult = false
    @Published var isGameOver = false
    @Published var isWin = false
    
    @Published var timeElapsed = 0
    @Published var isPaused = false
    private var timer: Timer?
    
    @Published var riddles: [Riddle] = []
    private var allRiddlesGroups: [[Riddle]] = []
    
    init() {
        loadRiddles()
        startTimer()
    }
    
    // MARK: - Timer Methods
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if !self.isPaused && !self.isGameOver && !self.isWin {
                self.timeElapsed += 1
            }
        }
    }
    
    func pauseTimer() {
        isPaused = true
    }
    
    func resumeTimer() {
        isPaused = false
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    var formattedTime: String {
        let minutes = timeElapsed / 60
        let seconds = timeElapsed % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func loadRiddles() {
        if let path = Bundle.main.path(forResource: "joker_riddles", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                let decoder = JSONDecoder()
                allRiddlesGroups = try decoder.decode([[Riddle]].self, from: data)
                
                selectRandomRiddleGroup()
            } catch {
                print("Error decoding riddles: \(error)")
                useBackupRiddles()
            }
        } else {
            print("Could not find joker_riddles.json")
            useBackupRiddles()
        }
    }
    
    private func selectRandomRiddleGroup() {
        guard !allRiddlesGroups.isEmpty else {
            useBackupRiddles()
            return
        }
        
        let randomIndex = Int.random(in: 0..<allRiddlesGroups.count)
        riddles = allRiddlesGroups[randomIndex]
        
        riddles.shuffle()
        
        if riddles.count > 10 {
            riddles = Array(riddles.prefix(10))
        }
    }
    
    private func useBackupRiddles() {
        riddles = [
            Riddle(
                id: 0,
                question: "You see four masks before you.\nOne changes, another cries, the third stays silent, the fourth whispers.\n\nIf the reflection is different — look at yourself.\n\nWhat will you choose?",
                options: ["The mask changes", "The mask cries", "The mask stays silent", "The mask whispers"],
                correctIndex: 1,
                explanation: "Hint: If the reflection is different — look at yourself."
            ),
            Riddle(
                id: 1,
                question: "You see four hats before you.\nOne smiles, another cries, the third stays silent, the fourth trembles.\n\nFear is a sign that you are close.\n\nWhat will you choose?",
                options: ["The hat smiles", "The hat cries", "The hat stays silent", "The hat trembles"],
                correctIndex: 1,
                explanation: "Hint: Fear is a sign that you are close."
            ),
            Riddle(
                id: 2,
                question: "You see four noses before you.\nOne laughs, another freezes, the third stares, the fourth twitches.\n\nIf the reflection is different — look at yourself.\n\nWhat will you choose?",
                options: ["The nose laughs", "The nose freezes", "The nose stares", "The nose twitches"],
                correctIndex: 2,
                explanation: "Hint: If the reflection is different — look at yourself."
            ),
            Riddle(
                id: 3,
                question: "You see four laughs before you.\nOne laughs, another screams, the third disappears, the fourth echoes.\n\nA clown always plays — even in front of himself.\n\nWhat will you choose?",
                options: ["The laugh laughs", "The laugh screams", "The laugh disappears", "The laugh echoes"],
                correctIndex: 0,
                explanation: "Hint: A clown always plays — even in front of himself."
            )
        ]
    }

    var currentRiddle: Riddle {
        riddles[currentRiddleIndex]
    }

    func submitAnswer(_ index: Int) {
        selectedIndex = index
        showResult = true

        if index == currentRiddle.correctIndex {
            nextRiddle()
        } else {
            isGameOver = true
            stopTimer()
        }
    }

    func nextRiddle() {
        if currentRiddleIndex + 1 >= riddles.count {
            isWin = true
            stopTimer()
        } else {
            currentRiddleIndex += 1
            selectedIndex = nil
            showResult = false
        }
    }

    func restart() {
        selectRandomRiddleGroup()
        currentRiddleIndex = 0
        selectedIndex = nil
        showResult = false
        isGameOver = false
        isWin = false
        
        timeElapsed = 0
        isPaused = false
        stopTimer()
        startTimer()
    }
    
    deinit {
        stopTimer()
    }
}
