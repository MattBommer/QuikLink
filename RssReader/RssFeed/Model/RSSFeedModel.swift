//
//  FeedModel.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//
import Foundation

struct RSSFeed: Identifiable, Decodable {
    var id: String
    var title: String
    var description: String?
    var feedUrl: URL?
    var imageUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case resourceId
        case title
        case description
        case url
        case imageURL
    }
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
        description = nil
        feedUrl = nil
        imageUrl = nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .resourceId)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String?.self, forKey: .description)
        
        if let url = try container.decode(String?.self, forKey: .url) {
            feedUrl = URL(string: url)
        } else {
            feedUrl = nil
        }
        
        if let imageUrlString = try container.decode(String?.self, forKey: .imageURL) {
            imageUrl = URL(string: imageUrlString)
        } else {
            imageUrl = nil
        }
    }
}
