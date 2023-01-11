//
//  FeedModel.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import Foundation

struct Feed: Decodable {
    var resourceId: String
    var title: String
    var description: String?
    var url: String
    var imageUrl: String?
}
