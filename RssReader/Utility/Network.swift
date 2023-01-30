//
//  Networking.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import Foundation

typealias HeaderValue = String
typealias HttpHeaderField = String
typealias HttpHeaders = [HttpHeaderField: HeaderValue]

enum ResponseError: Error {
    case clientError
    case serverError
    case unknownError
}

public enum Response<T>: Decodable where T: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
    }
    
    case success(T)
    case failed(String)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try container.decode(String.self, forKey: .status)
        
        switch status.lowercased() {
        case "success":
            let data = try container.decode(T.self, forKey: .data)
            self = .success(data)
        case "failed":
            let message = try container.decode(String.self, forKey: .message)
            self = .failed(message)
        default:
            throw DecodingError.dataCorruptedError(forKey: .status, in: container, debugDescription: "Invalid status type")
        }
    }
}

public enum HTTPMethod: String {
    case delete
    case get
    case patch
    case post
    case put
}

public struct EmptyBody: Codable {}

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

public class Network {
    
    static let shared: Network = Network()
    
    weak var authenticationDelegate: AuthViewModel?
    
    private let encoder: JSONEncoder
    
    private let decoder: JSONDecoder
        
    private let baseURL: URL?
    
    private init() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
        baseURL = URL(string: Bundle.main.object(forInfoDictionaryKey: "HOST_URL") as! String)
    }
    
    func fetch<T>(request: URLRequest) async throws -> Response<T> {
        let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
        let httpResponse = response as! HTTPURLResponse
        
        if let accessToken = httpResponse.value(forHTTPHeaderField: "access-token"),
           let refreshToken = httpResponse.value(forHTTPHeaderField: "refresh-token")
        {
            try JsonWebTokenStore.shared.setTokens(JWTTokens(refresh: refreshToken, access: accessToken))
        }
        
        switch httpResponse.statusCode {
        case 200...399:
            let decoded = try decoder.decode(Response<T>.self, from: data)
            return decoded
        case 401:
            // Log user out
            DispatchQueue.main.async { self.authenticationDelegate?.logOut() }
            throw ResponseError.clientError
        case 400, 402...499:
            throw ResponseError.clientError
            // Inform user that they filled something out wrong
        case 500...599:
            throw ResponseError.serverError
            // Problem on server side, tell user server is not working and to try again later
        default:
            throw ResponseError.unknownError
        }
    }
    
    func buildRequest(from requestInfo: RequestInfo) -> URLRequest? {
        guard let url = URL(string: requestInfo.path, relativeTo: baseURL) else { return nil }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = requestInfo.httpMethod.rawValue.capitalized
        request.httpBody = requestInfo.body
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        if requestInfo.needsAuthorizationToken, let token = JsonWebTokenStore.shared.fetchValidToken() {
            request.setValue("bearer \(token.string)", forHTTPHeaderField: "authorization")
        }
        
        if let headers = requestInfo.headers {
            headers.forEach { (field: HttpHeaderField, value: HeaderValue) in
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        
        return request
    }
}
