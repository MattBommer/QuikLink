//
//  FeedViewModel.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import Foundation
import FeedKit
import Combine


@MainActor class FeedStore: ObservableObject {
    
    typealias ArticleComparator = (Article, Article) -> ComparisonResult
    
    private var feedMap: [Feed : Set<Article>] = [:]
    
    @Published var displayArticles: [Article] = []
    
    var feeds: [Feed] {
        Array(feedMap.keys.sorted(by: { $0.title < $1.title }))
    }
    
    func addFeed(_ feedUrl: String) async throws {
        let requestInfo = RequestInfo(path: "feed/add", httpMethod: .post, body: AddFeed(feedUrl: feedUrl.lowercased()), needsAuthorizationToken: true)
        guard let request = Network.shared.buildRequest(from: requestInfo) else { return }
        
        let response: Response<Feed> = try await Network.shared.fetch(request: request)
        
        switch response {
        case .success(let feed):
            let articles = Set(await retrieveArticles(for: feed))
            feedMap[feed] = articles
            displayArticles.mergeInOrder(articles)
        case .failed(let message):
            print(message)
        }
    }
    
    private func retrieveArticles(for feed: Feed) async -> [Article] {
        await withCheckedContinuation{ continuation in
            _retrieveArcticles(for: feed) { articles in
                continuation.resume(returning: articles)
            }
        }
    }
    
    private func _retrieveArcticles(for feedMetaData: Feed, completion: @escaping ([Article]) -> Void) {
        let parser = FeedParser(URL: feedMetaData.feedUrl)
        
        let findImage = { (_ media: MediaNamespace?) -> String? in
            guard let media, let mediaContents = media.mediaContents else { return nil }
            let mediaContent = mediaContents.first { $0.attributes?.medium == "image" }
            return mediaContent?.attributes?.url
        }
        
        parser.parseAsync { result in
            var articles: [Article] = []
            switch result {
            case .success(let feed):
                switch feed {
                case .atom(let atomFeed):
                    guard let entries = atomFeed.entries else { return }
                    articles = entries.compactMap { entry in
                        return Article(publication: feedMetaData.title, url: entry.id, title: entry.title, datePublished: entry.published, imageUrl: findImage(entry.media))
                    }
                case .rss(let rssFeed):
                    guard let items = rssFeed.items else { return }
                    articles = items.compactMap { item in
                        Article(publication: feedMetaData.title, url: item.link, title: item.title, datePublished: item.pubDate, imageUrl: findImage(item.media))
                    }
                case .json(let jsonFeed):
                    guard let items = jsonFeed.items else { return }
                    articles = items.compactMap { item in
                        Article(publication: feedMetaData.title, url: item.url, title: item.title, datePublished: item.datePublished, imageUrl: item.image)
                    }
                }
            case .failure(let error):
                print(error)
            }
            
            completion(articles)
        }
    }
    
    func fetchFeeds() async throws {
        let requestInfo = RequestInfo(path: "feed/fetch", httpMethod: .get, needsAuthorizationToken: true)
        guard let request = Network.shared.buildRequest(from: requestInfo) else { return }
        
        let response: Response<[Feed]> = try await Network.shared.fetch(request: request)
        
        switch response {
        case .success(let feeds):
            await withTaskGroup(of: (Feed, [Article]).self, body: { [self] group in
                for feed in feeds {
                    group.addTask {
                        await (feed, self.retrieveArticles(for: feed))
                    }
                }
                
                feedMap = await group.reduce(into: [:]) { $0[$1.0] = Set($1.1) }
                feedMap.values.forEach { displayArticles.mergeInOrder($0) }
            })
        case .failed(let message):
            print(message)
        }
    }
    
    
    func removeFeed(_ feed: Feed) {
        let requestInfo = RequestInfo(path: "feed/remove", httpMethod: .post, body: RemoveFeed(feedId: feed.id), needsAuthorizationToken: true)
        guard let request = Network.shared.buildRequest(from: requestInfo) else { return }
        
        Task {
            let _: Response<EmptyBody> = try await Network.shared.fetch(request: request)
        }
        
        guard let deletedArticles = feedMap.removeValue(forKey: feed) else { return }
        displayArticles.remove(deletedArticles)
    }
}

private extension Array<Article> {
    mutating func mergeInOrder(_ setToMerge: Set<Article>) {
        let sort = { (a: Article, b: Article) -> Bool in
            a.datePublished > b.datePublished
        }
        guard !self.isEmpty else { self = setToMerge.sorted(by: sort); return}
        self = Set(self).union(setToMerge).sorted(by: sort)
    }
    
    mutating func remove(_ setToRemove: Set<Article>) {
        let prunedArticleSet = NSMutableOrderedSet(array: self)
        prunedArticleSet.minusSet(setToRemove)
        self = prunedArticleSet.array as! [Article]
    }
}
