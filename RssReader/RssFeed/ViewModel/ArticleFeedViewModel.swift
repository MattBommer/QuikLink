//
//  ArticleFeedViewModel.swift
//  RssReader
//
//  Created by Matt Bommer on 1/24/23.
//

import Foundation
import FeedKit

class ArticleFeedViewModel {
        
    func parseFeed(_ url: URL) -> Result<[Article], Error> {
        let parser = FeedParser(URL: url)
        let result = parser.parse()
        let articles: [Article]
        
        switch result {
        case .success(let feed):
            switch feed {
            case .atom(let atomFeed):
                guard let entries = atomFeed.entries else { return .success([]) }
                articles = entries.compactMap { Article(atomEntry: $0) }
            case .rss(let rssFeed):
                guard let items = rssFeed.items else { return .success([]) }
                articles = items.compactMap { Article(rssItem: $0) }
            case .json(let jsonFeed):
                guard let items = jsonFeed.items else { return .success([]) }
                articles = items.compactMap { Article(jsonItem: $0) }
            }
        case .failure(let error):
            return .failure(error)
        }
        
        return .success(articles)
    }
}
