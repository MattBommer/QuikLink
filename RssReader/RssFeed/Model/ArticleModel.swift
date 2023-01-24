//
//  RSSFeedItemModel.swift
//  RssReader
//
//  Created by Matt Bommer on 1/17/23.
//

import Foundation
import FeedKit

enum ArticleError: Error {
    case NoTitle
    case NoContentUrl
}

struct Article: Identifiable {
    var id: String?
    var title: String
    var description: String?
    var contentUrl: URL
    var imageUrl: URL?
    
    init?(atomEntry: AtomFeedEntry) {
        try? self.init(id: atomEntry.id,
                  title: atomEntry.title,
                  description: atomEntry.summary?.value,
                  contentUrl: atomEntry.id,
                  imageUrl: atomEntry.media?.mediaContents?.first?.attributes?.url)
    }
    
    init?(rssItem: RSSFeedItem) {
        try? self.init(id: rssItem.guid?.value,
                       title: rssItem.title,
                       description: rssItem.description,
                       contentUrl: rssItem.link,
                       imageUrl: rssItem.enclosure?.attributes?.url)
    }
    
    init?(jsonItem: JSONFeedItem) {
        try? self.init(id: jsonItem.id,
                       title: jsonItem.title,
                       description: jsonItem.summary,
                       contentUrl: jsonItem.url,
                       imageUrl: jsonItem.image)
    }
    
    init(id: String?, title: String?, description: String?, contentUrl: String?, imageUrl: String?) throws {
        guard let title = title else { throw ArticleError.NoTitle }
        guard let contentUrl = URL(string: contentUrl) else { throw ArticleError.NoContentUrl }
        
        self.title = title
        self.contentUrl = contentUrl
        self.id = id ?? UUID().uuidString
        self.description = description
        self.imageUrl = URL(string: imageUrl)
    }
}
