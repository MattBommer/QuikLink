//
//  Modifiers.swift
//  RssReader
//
//  Created by Matt Bommer on 1/18/23.
//

import SwiftUI

struct BorderedCard: ViewModifier {
    var backgroundColor: Color
    var strokeColor: Color
    var lineWidth: CGFloat
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
            .border(strokeColor, width: lineWidth)
    }
}

extension View {
    func borderedCard(backgroundColor: Color = .white, strokeColor: Color = .blue, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 9) -> some View {
        modifier(BorderedCard(backgroundColor: backgroundColor, strokeColor: strokeColor, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
}
