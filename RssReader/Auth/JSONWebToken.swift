//
//  JSONWebToken.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import Foundation

struct JWTToken: Codable {
    var refresh: String
    var access: String
}
