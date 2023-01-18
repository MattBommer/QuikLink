//
//  EmptyFeedView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/18/23.
//

import SwiftUI

struct EmptyFeedView: View {
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 75, height: 75, alignment: .center)
            Text("Subscribe to some RSS feeds to see more here")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 32)
        }
        .foregroundColor(.gray)
    }
}

struct EmptyFeedView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyFeedView()
    }
}
