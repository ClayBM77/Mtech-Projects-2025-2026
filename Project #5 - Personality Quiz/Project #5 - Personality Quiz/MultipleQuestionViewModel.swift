//
//  MultipleQuestionViewModel.swift
//  Project #5 - Personality Quiz
//
//  Created by Bridger Mason on 11/11/25.
//

import SwiftUI


@Observable class MultipleQuestionViewModel {
    
    
    var quizManager: QuizManager?
    
    
    var isOn1 = false
    var isOn2 = false
    var isOn3 = false
    var isOn4 = false
    var isOn5 = false
    
    func insertValue(answerNumber index: Int) {
        quizManager?.selectedAnswerMulti.append(quizManager!.questionList[2].answers[index].type)
    }
    
    func removeValue(value index: Int) {
        if let valueCheck = quizManager?.selectedAnswerMulti.firstIndex(of: quizManager!.questionList[2].answers[index].type) {
            quizManager?.selectedAnswerMulti.remove(at: valueCheck)
        }
    }
}
