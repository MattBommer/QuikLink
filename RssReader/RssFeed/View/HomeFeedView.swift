//
//  HomeFeedView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/19/23.
//

import SwiftUI

struct HomeFeedView: View {
    @EnvironmentObject private var rssFeedViewModel: RSSFeedViewModel
    var body: some View {
        if rssFeedViewModel.feeds.isEmpty {
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
        } else {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(rssFeedViewModel.feeds) { feed in
                            FeedView(feed: feed)
                        }
                    }
                    .padding([.leading, .trailing], 16)
                }
            }
        }
    }
}

struct HomeFeedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeFeedView()
    }
}
