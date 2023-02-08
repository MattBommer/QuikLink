//
//  FeedView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/31/23.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var feedStore: FeedStore
    var feed: Feed
    
    var body: some View {
        HStack {
            Text(feed.title)
                .padding()
            Spacer()
            
            HStack(spacing: 0) {
                Button {
                    feedStore.toggleFeed(feed)
                } label: {
                    Image(systemName: feed.articlesVisible ? "eye.slash.fill" : "eye.fill")
                        .renderingMode(.template)
                        .icon(size: CGSize(width: 30, height: 20), edges: [.leading, .trailing], padding: 8)
                        .tint(Color(uiColor: .brandGreen))
                }
                
                Button {
                    Task {
                        try await feedStore.removeFeed(feed)
                    }
                } label: {
                    Image(systemName: "trash.circle.fill")
                        .renderingMode(.template)
                        .icon(size: CGSize(width: 25, height: 25), edges: [.leading, .trailing], padding: 8)
                        .tint(Color(uiColor: .brandRed))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .brandWhite))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 0.5)
    }
}
