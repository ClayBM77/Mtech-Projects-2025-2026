//
//  ResultView.swift
//  Project #5 - Personality Quiz
//
//  Created by Bridger Mason on 10/14/25.
//

import SwiftUI

struct ResultView: View {
    @Environment(QuizManager.self) var quizManager
        var body: some View {
                    
                    VStack {
                        Text("You're a...")
                            .font(.headline)
                            .bold()
                        Text(quizManager.resultTitle)
                            .font(.largeTitle)
                            .bold()
                        switch quizManager.finalResult {
                        case .pikachu:
                            ZStack {
                                Image(systemName: "hare")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundStyle(.yellow)
                                    .offset(x: 40)
                                Image(systemName: "bolt")
                                    .resizable()
                                    .frame(width: 100, height: 100, alignment: .leading)

                                    .rotationEffect(.radians(.pi / 2))
                                    .offset(x: -52, y: -17)
                                    .foregroundStyle(
                                        Gradient(colors: [
                                            .black, .yellow, .yellow, .yellow,
                                        ])
                                    )
                            }
                        case .drampa:
                            
                            ZStack {
                                Image(systemName: "lizard")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundStyle(.mint)
                                    .offset(x: 40)
                                    .rotationEffect(.radians(-(.pi / 2)))
                            }
                            
                        case .oranguru:
                            
                            ZStack {
                               
                                Image(systemName: "leaf")
                                    .resizable()
                                    .frame(width: 100, height: 100, alignment: .leading)

                                    
                                    
                                    .foregroundStyle(
                                        .pink
                                    )
                            }
                             
                        case .torterra:
                            ZStack {
                                Image(systemName: "tortoise")
                                    .resizable()
                                    .frame(width: 200, height: 100)
                                    .foregroundStyle(.green)
                                    .offset(x: 20)
                                Image(systemName: "tree")
                                    .resizable()
                                    .frame(width: 100, height: 100, alignment: .leading)
                                    .offset(x: -8, y: -95)
                                    .foregroundStyle(.green)
                                    
                            }
                            
                        }
                        Text("\(quizManager.resultDescription)")
                            .foregroundStyle(.black)
                            .italic()
                            .padding()
                    
                            .padding()
                }
                .onAppear {
                    quizManager.calculateResults()
                }
                .navigationBarBackButtonHidden(true)
            }
        }
    


#Preview {
    ResultView()
}
