//
//  FeedViewModel.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import Foundation

class FeedViewModel: ObservableObject {
    @Published var feeds: [Feed] = []
    let feedUrls: [URL]
    
    init(feeds: [URL]) {
        feedUrls = feeds
    }
    
    func addFeed() {
        
    }
    
    func retrieveFeed() {
        
    }
    
    func removeFeed() {
        
    }
    
    func updateFeed() {
        
    }
    
//    func perform(action: FeedAction)
//    
//    func fetchFeeds(with url: URL) async throws {
//        let host = "localhost"
//        let path = "feed"
//        let endpoint = "fetch"
//        
//        let urlComponents = URLComponents()
//        urlComponents.host = host
//        urlComponents.endpoint
//        
//        let (data, _) = try await URLSession.shared.data(from: url)
//        let decoder = JSONDecoder()
//        let feed = try decoder.decode(Feed.self, from: data)
//        
//    }
}
