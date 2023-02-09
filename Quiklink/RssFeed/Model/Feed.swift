//
//  Feed.swift
//  Quiklink
//
//  Created by Matt Bommer on 1/10/23.
//
import Foundation

struct Feed: Identifiable, Decodable, Hashable {
    var id: String
    var title: String
    var description: String?
    var feedUrl: URL
    var imageUrl: URL?
    var articlesVisible: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case resourceId
        case title
        case description
        case url
        case imageURL
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .resourceId)
        title = try container.decode(String.self, forKey: .title)
        if let url = URL(string: try container.decode(String.self, forKey: .url)) {
            feedUrl = url
        } else {
            throw URLError(.badURL)
        }
        description = try container.decode(String?.self, forKey: .description)
        imageUrl = URL(string: try container.decode(String?.self, forKey: .imageURL))
    }
}
