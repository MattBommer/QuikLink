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
    
    let articles: [Article] = [.sample, .sample2]
    
    var body: some View {
        RootModalView(backgroundColor: Color(uiColor: .gray.withAlphaComponent(0.3))) {
            VStack(spacing: 0) {
                HomeHeaderView()
                
                // Feed
                ScrollView {
                    LazyVStack {
                        ForEach(articles, id: \.id) { article in
                            ArticleView(article: article)
                        }
                    }
                    .padding([.top], 8)
                    .padding([.leading, .trailing], 16)
                }
            }
        }
    }
}

struct RSSFeedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
