//
//  RequestInfo.swift
//  RssReader
//
//  Created by Matt Bommer on 2/7/23.
//

import Foundation

typealias HeaderValue = String
typealias HttpHeaderField = String
typealias HttpHeaders = [HttpHeaderField: HeaderValue]

public enum HTTPMethod: String {
    case delete
    case get
    case patch
    case post
    case put
}

struct RequestInfo {
    var path: String
    var httpMethod: HTTPMethod
    var headers: HttpHeaders?
    var body: Data?
    var needsAuthorizationToken: Bool
    
    init<T>(path: String, httpMethod: HTTPMethod, headers: HttpHeaders? = nil, body: T, needsAuthorizationToken: Bool) where T : Encodable {
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
        self.body = try? JSONEncoder().encode(body)
        self.needsAuthorizationToken = needsAuthorizationToken
    }
    
    init(path: String, httpMethod: HTTPMethod, headers: HttpHeaders? = nil, needsAuthorizationToken: Bool) {
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
        self.needsAuthorizationToken = needsAuthorizationToken
    }
}
