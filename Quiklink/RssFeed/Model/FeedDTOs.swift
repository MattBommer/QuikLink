//
//  AddFeedModel.swift
//  RssReader
//
//  Created by Matt Bommer on 1/20/23.
//

import Foundation

struct AddFeed: Codable {
    let feedUrl: String
}

struct RemoveFeed: Codable {
    let feedId: String
}
