//
//  RSSFeedView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/12/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var rssFeedViewModel = RSSFeedViewModel()
    @State private var headerHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
                switch rssFeedViewModel.state {
                case .idle where rssFeedViewModel.feeds.isEmpty:
                    EmptyFeedView()
                case .loading where rssFeedViewModel.feeds.isEmpty:
                    ProgressView()
                case .idle, .loading:
                    VStack {
                        Spacer()
                            .frame(height: 75)
                        ScrollView {
                            LazyVStack {
                                ForEach(rssFeedViewModel.feeds) { feed in
                                    FeedView(feed: feed)
                                }
                            }
                        }
                    }
                }
            
            HomeHeaderView()
            RefreshFloatingActionButtonView()
                .environmentObject(rssFeedViewModel)
        }
        .onAppear {
            Task {
                try await rssFeedViewModel.fetchFeeds()
            }
        }
    }
}

struct RSSFeedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
