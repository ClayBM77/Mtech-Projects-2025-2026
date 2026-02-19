//
//  QuizView.swift
//  Project #5 - Personality Quiz
//
//  Created by Bridger Mason on 10/14/25.
//

import SwiftUI

struct Question: Equatable {
    static func == (lhs: Question, rhs: Question) -> Bool {
        lhs.text == rhs.text
    }

    var text: String
    var type: ResponseType
    var answers: [Answer]
}
enum ResponseType {
    case single, ranged, multiple
}

struct Answer {
    var text: String
    var type: Pokemon
}

enum Pokemon {
    case pikachu, torterra, drampa, oranguru
}

@Observable class QuizManager {
    var currentQuestion: Int = 0
    var navigationStack: [Int] = []
    var selectedAnswers: [Pokemon] = []
    var sliderValue: Double = 0
    
    var selectedAnswerSingle: [Pokemon] = []
    var selectedAnswerRanged: [Pokemon] = []
    var selectedAnswerMulti: [Pokemon] = []
    
    var resultTitle = ""
    var resultDescription = ""
    var finalResult: Pokemon = .pikachu
    
    
    func selectAnswer(_ answer: Pokemon) {
        selectedAnswers.append(answer)
    }
    
    func removeSelectedAnswer() {
        guard selectedAnswers.count >= currentQuestion else { return }
        selectedAnswers.remove(at: currentQuestion)
        
    }
    
    func resetAnswers() {
        resultTitle = ""
        resultDescription = ""
        
        currentQuestion = 0
        
        selectedAnswerMulti.removeAll()
        selectedAnswerRanged.removeAll()
        selectedAnswerSingle.removeAll()
        
        navigationStack.removeAll()
    }
    
    func calculateResults() {
        var result: Pokemon = .pikachu
        let all = selectedAnswerSingle + selectedAnswerRanged + selectedAnswerMulti
        
        
            let counts = Dictionary(all.map { ($0, 1) }, uniquingKeysWith: +)
            
            let maxCount = counts.values.max() ?? 0
            let mostCommonTypes = counts.filter { $0.value == maxCount }.map { $0.key }
            
            if let winner = all.first(where: { mostCommonTypes.contains($0) }) {
                result = winner
                
            finalResult = result
        }
        switch result {
        case .pikachu:
            resultTitle = "Pikachu!"
            resultDescription = "You’re energetic, loyal, and instantly lovable. People feel brighter just being around you, and you always bring a spark to the group."
        case .oranguru:
            resultTitle = "Oranguru!"
            resultDescription = "You’re the quiet genius of your friend group. Thoughtful, observant, and strategic, you always know more than you say."
        case .drampa:
            resultTitle = "Drampa!"
            resultDescription = "You’re gentle, caring, and wonderfully quirky. You defend the people you love with surprising ferocity—and give the best hugs."
        case .torterra:
            resultTitle = "Torterra!"
            resultDescription = "You’re grounded, steady, and wise beyond your years. Friends rely on your calm presence and big-picture perspective."
        }
    }


    
    
    
    let questionList: [Question] = [
        Question(
            text: "Which sauce do you like the most? (Pick One)",
            type: .single,
            answers: [
                Answer(text: "Ketchup", type: .pikachu),
                Answer(text: "Worchestershire Sauce", type: .torterra),
                Answer(text: "Hot Sauce", type: .drampa),
                Answer(text: "Soy Sauce", type: .oranguru),
            ]
        ),
        Question(
            text: "How energetic are you?",
            type: .ranged,
            answers: [
                Answer(text: "not very much at all", type: .oranguru),
                Answer(text: "A wee bit", type: .drampa),
                Answer(text: "A good amount", type: .torterra),
                Answer(text: "YES!!!!!!", type: .pikachu),
            ]
        ),
        Question(
            text: "Which activities do you enjoy?",
            type: .multiple,
            answers: [
                Answer(text: "Surfing", type: .pikachu),
                Answer(text: "Hanging Out with Friends", type: .torterra),
                Answer(text: "Sleeping", type: .drampa),
                Answer(text: "Spending time in nature", type: .oranguru),
            ]
        ),
        Question(
            text: "What is your favorite season? (Pick One)",
            type: .single,
            answers: [
                Answer(text: "Summer", type: .pikachu),
                Answer(text: "Spring", type: .torterra),
                Answer(text: "Autumn", type: .drampa),
                Answer(text: "Winter", type: .oranguru)
                ]
            )
    ]
    
    func nextQuestion(after question: Question) -> Int {
        let index = questionList.firstIndex(of: question)!
        return index + 1
    }
}

struct QuestionFlowView: View {
    @Environment(QuizManager.self) var quizManager
    let question: Question
    
    init(question: Question) {
        self.question = question
    }
    
    var body: some View {
        VStack {
            switch question.type {
            case .single:
                SingleQuestionSubview(question: question)
            case .ranged:
                RangedQuestionSubview(question: question)
            case .multiple:
                MultipleQuestionSubview(question: question)
            }
        }
        .toolbar {
            ToolbarItem {
                Button("Next") {
                    quizManager.navigationStack.append(quizManager.nextQuestion(after: question))
                }
                .navigationTitle(Text("Question \(quizManager.nextQuestion(after: question))"))
                    
                }
            
        }

    }

}

#Preview {
    @Previewable @State var quizManager = QuizManager()
    QuestionFlowView(question: QuizManager().questionList[0])
        .environment(quizManager)
}
