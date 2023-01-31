//
//  FeedView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/31/23.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var feedViewModel: RSSFeedViewModel
    var feed: FeedMetaData
    
    var body: some View {
        HStack {
            Text(feed.title)
                .padding()
            Spacer()
            Button {
                feedViewModel.removeFeed(feed.id)
            } label: {
                Image(systemName: "trash.circle.fill")
                    .renderingMode(.template)
                    .icon(size: CGSize(width: 30, height: 30))
                    .tint(Color(uiColor: .brandRed))
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .brandWhite))
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}
