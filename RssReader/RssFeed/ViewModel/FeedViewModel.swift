//
//  FeedViewModel.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import Foundation

enum HomeFeedStatus {
    case normal
    case edit
}

@MainActor
class RSSFeedViewModel: ObservableObject {
    
    @Published var feeds: [FeedMetaData] = []
    
    @Published var homeFeedStatus: HomeFeedStatus = .normal
    
    func addFeed(_ feedUrl: String) async throws {
        let requestInfo = RequestInfo(path: "feed/add", httpMethod: .post, body: AddFeed(feedUrl: feedUrl.lowercased()))
        guard let request = Network.shared.buildRequest(from: requestInfo, authToken: .access) else { return }
        
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
    
    func fetchFeeds() async throws {
        let requestInfo = RequestInfo(path: "feed/fetch", httpMethod: .get)
        guard let request = Network.shared.buildRequest(from: requestInfo, authToken: .access) else { return }
        
        let response: Response<[FeedMetaData]> = try await Network.shared.fetch(request: request)
        
        switch response {
        case .success(let feeds):
            await MainActor.run(body: {
                self.feeds = feeds
            })
        case .failed(let message):
            print(message)
        }
    }
    
    func removeFeed(_ feedId: String) {
        let requestInfo = RequestInfo(path: "feed/remove", httpMethod: .post, body: RemoveFeed(feedId: feedId))
        guard let request = Network.shared.buildRequest(from: requestInfo, authToken: .access) else { return }
        
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
