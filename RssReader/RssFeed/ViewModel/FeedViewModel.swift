//
//  FeedViewModel.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import Foundation

@MainActor
class RSSFeedViewModel: ObservableObject {
    
    enum State {
        case idle
        case loading
    }
        
    @Published var feeds: [RSSFeed] = []
    
    @Published private(set) var state: State = .idle
        
    func addFeed() {
        
    }
    
    func fetchFeeds() async throws {
        await MainActor.run{ state = .loading }
        
        defer {
            Task {
                await MainActor.run { state = .idle }
            }
        }
        
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
