//
//  FeedViewModel.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import Foundation
import FeedKit



@MainActor
class RSSFeedViewModel: ObservableObject {
    
    @Published var feeds: [FeedMetaData] = []
    
    @Published var articles: [Article] = []
        
    func addFeed(_ feedUrl: String) async throws {
        let requestInfo = RequestInfo(path: "feed/add", httpMethod: .post, body: AddFeed(feedUrl: feedUrl.lowercased()), needsAuthorizationToken: true)
        guard let request = Network.shared.buildRequest(from: requestInfo) else { return }
        
        let response: Response<FeedMetaData> = try await Network.shared.fetch(request: request)
        
        switch response {
        case .success(let feed):
            await MainActor.run(body: {
                self.feeds.append(feed)
            })
        case .failed(let message):
            print(message)
        }
    }
    
    func parseFeeds(_ feeds: [FeedMetaData]) {
        let parsers = feeds.map { FeedParser(URL: $0.feedUrl) }
        parsers.forEach { parser in
            parser.parseAsync { result in
                var articles: [Article]?
                switch result {
                case .success(let feed):
                    switch feed {
                    case .atom(let atomFeed):
                        guard let entries = atomFeed.entries else { return }
                        articles = entries.compactMap { Article(atomEntry: $0) }
                    case .rss(let rssFeed):
                        guard let items = rssFeed.items else { return }
                        articles = items.compactMap { Article(rssItem: $0) }
                    case .json(let jsonFeed):
                        guard let items = jsonFeed.items else { return }
                        articles = items.compactMap { Article(jsonItem: $0) }
                    }
                case .failure(let error):
                    print(error)
                }
                
                guard let articles = articles else { return }
                DispatchQueue.main.async { self.articles += articles }
            }
        }
    }
    
    func fetchFeeds() async throws {
        let requestInfo = RequestInfo(path: "feed/fetch", httpMethod: .get, needsAuthorizationToken: true)
        guard let request = Network.shared.buildRequest(from: requestInfo) else { return }
        
        let response: Response<[FeedMetaData]> = try await Network.shared.fetch(request: request)
        
        switch response {
        case .success(let feeds):
            parseFeeds(feeds)
            await MainActor.run(body: {
                self.feeds = feeds
            })
        case .failed(let message):
            print(message)
        }
    }
    
    
    
    func removeFeed(_ feedId: String) {
        let requestInfo = RequestInfo(path: "feed/remove", httpMethod: .post, body: RemoveFeed(feedId: feedId), needsAuthorizationToken: true)
        guard let request = Network.shared.buildRequest(from: requestInfo) else { return }
        
        Task {
            let _: Response<EmptyBody> = try await Network.shared.fetch(request: request)
        }
        
        for (index, feed) in feeds.enumerated() {
            if feedId == feed.id {
                feeds.remove(at: index)
                break
            }
        }
    }
}
