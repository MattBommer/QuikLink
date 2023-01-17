//
//  FeedModel.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//
struct RSSFeed: Decodable {
    var resourceId: String
    var title: String
    var description: String?
    var rssUrl: String
    var imageUrl: String?
}
