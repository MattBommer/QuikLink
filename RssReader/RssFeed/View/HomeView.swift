//
//  RSSFeedView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/12/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var modalStore: ModalStore
    @StateObject private var feedStore = FeedStore()
    
    var body: some View {
        VStack(spacing: 0) {
            HomeHeaderView()
                .environmentObject(feedStore)
            
            // Feed
            ZStack {
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
                    fetchFeeds()
                }
                
                if feedStore.displayArticles.isEmpty {
                    EmptyFeedView()
                }
            }
        }
        .onAppear {
            fetchFeeds()
        }
    }
    
    func fetchFeeds() {
        Task {
            do {
                try await feedStore.fetchFeeds()
            } catch {
                error.displayMessage(with: modalStore)
            }
        }
    }
    
}

struct RSSFeedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
