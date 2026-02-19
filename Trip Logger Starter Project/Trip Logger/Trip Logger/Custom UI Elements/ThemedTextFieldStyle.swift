//
//  ThemedTextFieldStyle.swift
//  Trip Logger
//
//  Created by Auto on 4/29/25.
//

import SwiftUI

struct ThemedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.appCardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.appOrange.opacity(0.3), lineWidth: 1.5)
                    )
                    .shadow(color: Color.appOrange.opacity(0.1), radius: 4, x: 0, y: 2)
            )
            .foregroundColor(.black)
    }
}

extension TextFieldStyle where Self == ThemedTextFieldStyle {
    static var themed: ThemedTextFieldStyle {
        ThemedTextFieldStyle()
    }
}
