//
//  ContentView.swift
//  WordScramble
//
//  Created by Mac on 26/06/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var score = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Image("word-scramble").resizable()
                            .scaledToFit()
                            .frame(height: 70)
                            .padding()
                    }
                    .padding()
                    
                    ZStack {
                        HStack {
                            Text("\(rootWord)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .padding()
                            
                            Spacer()
                            
                            Text("Score: \(score)")
                                .font(.title2)
                                .padding()
                        }
                        .padding(24)
                        .frame(height: 50)
                        .background(Color.blue.opacity(0.05))
                    }
                    
                    List {
                        Section {
                            TextField("Enter your word", text: $newWord)
                                .textInputAutocapitalization(.never)
                                .placeholder(when: newWord.isEmpty) {
                                    Text("Enter your word")
                                        .foregroundColor(Color.primary.opacity(0.3))
                                }
                        }
                        
                        Section {
                            ForEach(usedWords, id: \.self) { word in
                                HStack {
                                    Image(systemName: "\(word.count).circle")
                                    Text(word)
                                }
                                .accessibilityElement()
                                .accessibilityLabel(word)
                                .accessibilityHint("\(word.count) letters")
                            }
                        }
                    }
                    .onSubmit(addNewWord)
                    .onAppear(perform: startGame)
                    .alert(errorTitle, isPresented: $showingError) {
                        Button("OK") { }
                    } message: {
                        Text(errorMessage)
                    }
                }
                
                VStack {
                    Spacer()
                    Button(action: {
                        startGame()
                    }) {
                        Text("Restart")
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    .padding()
                }
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 2 else {
            wordError(title: "Word too short", message: "Words must be at least 3 letters long.")
            return
        }
        
        guard answer != rootWord else {
            wordError(title: "Same as root word", message: "You can't use the same word as the start word!")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        calculateScore(for: answer)
        
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                usedWords.removeAll()
                score = 0
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func calculateScore(for word: String) {
        score += word.count
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}

#Preview {
    ContentView()
}
