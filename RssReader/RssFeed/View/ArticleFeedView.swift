//
//  ArticleView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/23/23.
//

import SwiftUI
import FeedKit

struct ArticleFeedView: View {
    var rssFeed: FeedMetaData
    var viewModel = ArticleFeedViewModel()
    @State var articles: [Article] = []
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(articles) { article in
                    ArticleView(article: article)
                }
            }
        }
        .onAppear {
            let result = viewModel.parseFeed(rssFeed.feedUrl)
            switch result {
            case .success(let articles):
                self.articles = articles
            case .failure(let error):
                print(error)
            }
        }
    }
}
