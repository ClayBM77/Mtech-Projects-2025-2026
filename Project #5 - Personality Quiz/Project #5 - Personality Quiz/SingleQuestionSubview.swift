//
//  SingleQuestionSubview.swift
//  Project #5 - Personality Quiz
//
//  Created by Bridger Mason on 11/11/25.
//

import SwiftUI

struct SingleQuestionSubview: View {
    @Environment(QuizManager.self) var quizManager
    let question: Question
    @State private var currentAnswer: Int = 0
    @State private var questionOneIsOn = false
    @State private var questionTwoIsOn = false
    @State private var questionThreeIsOn = false
    @State private var questionFourIsOn = false
    

    var body: some View {
        VStack {
            Text(question.text)
                .font(.largeTitle)
                .bold()
                .padding()
            List {
                Toggle(isOn: $questionOneIsOn) {
                    Text(question.answers[0].text)
                        .font(.title3)
                        .bold()
                        .onChange(of: questionOneIsOn) { oldValue, newValue in
                            if newValue {
                                questionTwoIsOn = false
                                questionThreeIsOn = false
                                questionFourIsOn = false

                                quizManager.selectedAnswerSingle.removeAll()
                                quizManager.selectedAnswerSingle.append(question.answers[0].type)
                            }
                        }
                }
                .padding()
                Toggle(isOn: $questionTwoIsOn) {
                    Text(question.answers[1].text)
                        .font(.title3)
                        .bold()
                        .onChange(of: questionTwoIsOn) { oldValue, newValue in
                            if newValue {
                                questionOneIsOn = false
                                questionThreeIsOn = false
                                questionFourIsOn = false

                                quizManager.selectedAnswerSingle.removeAll()
                                quizManager.selectedAnswerSingle.append(question.answers[1].type)
                            }
                            if oldValue {

                            }
                        }
                }
                .padding()
                Toggle(isOn: $questionThreeIsOn) {
                    Text(question.answers[2].text)
                        .font(.title3)
                        .bold()
                        .onChange(of: questionThreeIsOn) { oldValue, newValue in
                            if newValue {
                                questionOneIsOn = false
                                questionTwoIsOn = false
                                questionFourIsOn = false

                                quizManager.selectedAnswerSingle.removeAll()
                                quizManager.selectedAnswerSingle.append(question.answers[2].type)
                            }
                        }
                }
                .padding()
                Toggle(isOn: $questionFourIsOn) {
                    Text(question.answers[3].text)
                        .font(.title3)
                        .bold()
                        .onChange(of: questionFourIsOn) { oldValue, newValue in
                            if newValue {
                                questionOneIsOn = false
                                questionTwoIsOn = false
                                questionThreeIsOn = false

                                quizManager.selectedAnswerSingle.removeAll()
                                quizManager.selectedAnswerSingle.append(question.answers[3].type)
                            }
                        }
                }
                .padding()
            }
        }
    }
}
