//
//  RangedQuestionSubview.swift
//  Project #5 - Personality Quiz
//
//  Created by Bridger Mason on 11/11/25.
//


import SwiftUI

struct RangedQuestionSubview: View {
    @Environment(QuizManager.self) var quizManager
    let question: Question
    var body: some View {
        VStack {
            Text(question.text)
                .font(.largeTitle)
                .bold()
            Text(question.answers[Int(quizManager.sliderValue)].text)
                .padding()
            Slider(
                value: Binding(
                    get: { quizManager.sliderValue },
                    set: { quizManager.sliderValue = $0 }
                ),
                in: 0...3,
                step: 1
            )
            .onDisappear {
                quizManager.selectedAnswerRanged.append(question.answers[Int(quizManager.sliderValue)].type)
                print("Ranged Array: \(quizManager.selectedAnswerRanged)")
            }
            .onAppear {
                quizManager.selectedAnswerRanged.removeAll()
                print("Ranged Array: \(quizManager.selectedAnswerRanged)")
            }
                .padding()
        }
    }
        
}
