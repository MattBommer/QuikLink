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
            Spacer()
            Button {
                feedViewModel.removeFeed(feed.id)
            } label: {
                Image(systemName: "trash.circle.fill")
                    .resizable()
                    .renderingMode(.template)
                    .tint(Color(uiColor: .brandRed))
                    .frame(width: 40, height: 40)
                    
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(uiColor: .brandWhite))
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}
