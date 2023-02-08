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

struct Article: Identifiable, Hashable {
    var id: String
    var title: String
    var datePublished: Date
    var publication: String
    var contentUrl: URL
    var imageUrl: URL?
    
    init?(publication: String, url: String?, title: String?, datePublished: Date?, imageUrl: String?) {
        guard let url = url,
              let title = title,
              let datePublished = datePublished,
              let contentUrl = URL(string: url) else { return nil }
        
        self.id = url
        self.title = title
        self.contentUrl = contentUrl
        self.datePublished = datePublished
        self.publication = publication
        self.imageUrl = URL(string: imageUrl)
    }
    
    var publishedString: String {
        let delta = -datePublished.timeIntervalSinceNow
        
        if delta < TimeInterval.minute {
            return "\(Int(delta))s ago"
        } else if delta < TimeInterval.hour {
            return "\(Int(delta / .minute))m ago"
        } else if delta < TimeInterval.day {
            return "\(Int(delta / .hour))h ago"
        } else if delta < TimeInterval.day * 2 {
            return "Yesterday"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY"
        return dateFormatter.string(from: datePublished)
    }
}

extension TimeInterval {
    
    static let day = 24 * hour
    
    static let hour = 60 * minute
    
    static let minute = 60.0
}
