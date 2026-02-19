//
//  MultipleQuestionSubview.swift
//  Project #5 - Personality Quiz
//
//  Created by Bridger Mason on 11/11/25.
//


import SwiftUI

struct MultipleQuestionSubview: View {
    @Environment(QuizManager.self) var quizManager
    let question: Question
    
    //@State private var isOn1 = false
    //@State private var isOn2 = false
    //@State private var isOn3 = false
    //@State private var isOn4 = false
    @State private var multipleQuestionViewModel = MultipleQuestionViewModel()
    
    var body: some View {
        
            Text(question.text)
                .font(.largeTitle)
                .bold()
            
            List {
                Group {
                    Toggle(isOn: $multipleQuestionViewModel.isOn1) {
                        Text(question.answers[0].text)
                    }
                    Toggle(isOn: $multipleQuestionViewModel.isOn2) {
                        Text(question.answers[1].text)
                    }
                    Toggle(isOn: $multipleQuestionViewModel.isOn3) {
                        Text(question.answers[2].text)
                    }
                    Toggle(isOn: $multipleQuestionViewModel.isOn4) {
                        Text(question.answers[3].text)
                    }
                    
                }
                .padding()
                .bold()
            }
            .background(.fill)
            .clipShape(RoundedRectangle(cornerRadius: 40))
        }
    
}
