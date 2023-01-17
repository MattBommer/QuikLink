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
    
    func addFeed() {
        
    }
    
    func fetchFeeds() async throws {
        let requestInfo: RequestInfo<String> = RequestInfo(path: "feed/fetch", httpMethod: .get, headers: nil, body: nil)
        guard let request = Network.shared.buildRequest(from: requestInfo, needsAuthHeader: true) else { return }
        
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