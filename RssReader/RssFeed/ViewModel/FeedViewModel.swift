//
//  FeedViewModel.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import Foundation

@MainActor
class RSSFeedViewModel: ObservableObject {
        
    @Published var feeds: [RSSFeed] = []
            
    func addFeed(_ feedUrl: String) async throws {
        let body = AddFeed(feedUrl: feedUrl)
        let requestInfo = RequestInfo(path: "feed/add", httpMethod: .get, headers: nil, body: body)
        guard let request = Network.shared.buildRequest(from: requestInfo, authToken: .access) else { return }
        
        let response: Response<RSSFeed> = try await Network.shared.fetch(request: request)
        
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
        let requestInfo: RequestInfo<String> = RequestInfo(path: "feed/fetch", httpMethod: .get, headers: nil, body: nil)
        guard let request = Network.shared.buildRequest(from: requestInfo, authToken: .access) else { return }
        
        let response: Response<[RSSFeed]> = try await Network.shared.fetch(request: request)
        
        switch response {
        case .success(let feeds):
            await MainActor.run(body: {
                self.feeds = feeds
            })
        case .failed(let message):
            print(message)
        }
    }
    
    func removeFeed() {
        
    }
}
