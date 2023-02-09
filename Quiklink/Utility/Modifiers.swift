//
//  Modifiers.swift
//  Quiklink
//
//  Created by Matt Bommer on 1/18/23.
//

import SwiftUI

struct StrokeView: ViewModifier {
    var backgroundColor: UIColor
    var strokeColor: UIColor
    var lineWidth: CGFloat
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(uiColor: backgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color(uiColor: strokeColor), lineWidth: lineWidth)
            )
    }
}

struct Fill: ViewModifier {
    var backgroundColor: UIColor
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(uiColor: backgroundColor))
            )
    }
}

extension View {
    func outline(backgroundColor: UIColor = .white, strokeColor: UIColor = .blue, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 8) -> some View {
        modifier(StrokeView(backgroundColor: backgroundColor, strokeColor: strokeColor, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
    
    func fill(backgroundColor: UIColor, cornerRadius: CGFloat = 8) -> some View {
        modifier(Fill(backgroundColor: backgroundColor, cornerRadius: cornerRadius))
    }
}
