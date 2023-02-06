//
//  RSSFeedView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/12/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var feedStore = FeedStore()
    
    var body: some View {
        RootModalView(backgroundColor: Color(uiColor: .gray.withAlphaComponent(0.3))) {
            VStack(spacing: 0) {
                HomeHeaderView()
                    .environmentObject(feedStore)
                
                // Feed
                ScrollView {
                    LazyVStack (spacing: 16) {
                        ForEach(feedStore.displayArticles, id: \.id) { article in
                            ArticleView(article: article)
                        }
                    }
                    .padding([.top], 8)
                    .padding([.leading, .trailing], 16)
                }
                .refreshable {
                    do {
                        try await feedStore.fetchFeeds()
                        print("is this happening?")
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .onAppear {
            Task {
                try await feedStore.fetchFeeds()
            }
        }
    }
}

struct RSSFeedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
