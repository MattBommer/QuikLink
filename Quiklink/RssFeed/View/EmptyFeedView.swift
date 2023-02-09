//
//  EmptyFeedView.swift
//  Quiklink
//
//  Created by Matt Bommer on 2/8/23.
//

import SwiftUI

struct EmptyFeedView: View {
    @State private var scaleFactor: CGFloat = 1.0
    @State private var translationValue: CGFloat = 0
    
    var repeatAnimation: Animation {
        Animation
            .easeInOut(duration: 2)
            .repeatForever(autoreverses: true)
    }
    
    var body: some View {
        
        VStack(spacing: 24) {
            HStack {
                Image(systemName: "arrow.up")
                    .icon(size: CGSize(width: 18, height: 24))
                    .offset(y: translationValue)
                    .onAppear {
                        withAnimation(self.repeatAnimation) {
                            self.translationValue = 20
                        }
                    }
                Spacer()
            }
            Spacer()
            Image(uiImage: UIImage(named: "quiklink")!)
                .icon(size: CGSize(width: 100, height: 100))
                .scaleEffect(scaleFactor)
                .onAppear {
                    withAnimation(self.repeatAnimation) {
                        self.scaleFactor = 1.1
                    }
                }
            Text("Add feeds to see your favorite content here!")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing])
            Spacer()
        }
    }
}

struct EmptyFeedView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyFeedView()
    }
}
