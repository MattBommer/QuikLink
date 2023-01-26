//
//  GradientLoadingView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/26/23.
//

import SwiftUI

struct GradientLoadingView: View {
    @State private var isAnimating: Bool = false
    
    var body: some View {
        LinearGradient(colors: [Color(uiColor: .brandPurple), Color(uiColor: .brandRed)], startPoint: .topLeading, endPoint: .bottomTrailing)
            .hueRotation(.degrees(isAnimating ? 30 : 0))
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                    isAnimating.toggle()
                }
            }
    }
}

struct GradientLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        GradientLoadingView()
    }
}
