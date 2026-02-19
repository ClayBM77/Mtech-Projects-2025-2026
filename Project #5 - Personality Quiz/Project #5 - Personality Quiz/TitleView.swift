//
//  ContentView.swift
//  Project #5 - Personality Quiz
//
//  Created by Bridger Mason on 10/14/25.
//

import SwiftUI

struct TitleView: View {
    @State var quizManager = QuizManager()

    var body: some View {
        NavigationStack(path: $quizManager.navigationStack) {
            VStack {
                
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
                
                /*
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
                 */
                /*
                ZStack {
                   
                    Image(systemName: "leaf")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .leading)

                        
                        
                        .foregroundStyle(
                            .pink
                        )
                }
                 */
                /*
                ZStack {
                    Image(systemName: "lizard")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.mint)
                        .offset(x: 40)
                        .rotationEffect(.radians(-(.pi / 2)))
                }
*/
                Text("What Pokemon Are You?")
                    .font(.custom("HelveticaNeue-CondensedBlack", size: 30))
                    .foregroundStyle(Color(.teal))
                    .shadow(radius: 20)

                Button {
                    quizManager.navigationStack.append(quizManager.currentQuestion)
                } label: {
                    Text("Begin Quiz!")
                }
                .clipShape(Capsule())
                .padding()
                .glassEffect()
                .foregroundStyle(Color(.black))

            }
            .navigationDestination(for: Int.self) { index in
                if index <= quizManager.questionList.count - 1 {
                    QuestionFlowView(question: quizManager.questionList[index])
                } else {
                    ResultView()
                }
            }

            .padding()
        }
        .environment(quizManager)
    }
}
#Preview {
    TitleView()
}
